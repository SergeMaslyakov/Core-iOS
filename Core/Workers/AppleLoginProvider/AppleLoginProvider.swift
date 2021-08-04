import AuthenticationServices
import UIKit

import RxCocoa
import RxSwift

public final class AppleLoginProvider: NSObject {
    public enum AppleLoginProviderError: Error {
        case unknown
        case cancelled
        case underlyingError(Error)
    }

    public struct RequestResult {
        public let userId: String
        public let givenName: String?
        public let familyName: String?
        public let identityToken: String
        public let authCode: String
    }

    public enum CheckResult {
        case authorized
        case notFound(Error?)
    }

    private let storage: DataStorageProtocol
    private let appleIDProvider: ASAuthorizationAppleIDProvider

    private var authController: ASAuthorizationController?
    private var requestCompletion: ((RequestResult?, Error?) -> Void)?

    public weak var presentationContextDelegate: ASAuthorizationControllerPresentationContextProviding?

    public init(storage: DataStorageProtocol) {
        self.storage = storage
        appleIDProvider = ASAuthorizationAppleIDProvider()

        super.init()
    }

    public func requestCredential() -> Single<RequestResult> {
        Single.create { [unowned self] observer -> Disposable in
            assert(Thread.isMainThread)

            let request = self.appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            self.authController = ASAuthorizationController(authorizationRequests: [request])
            self.authController?.delegate = self
            self.authController?.presentationContextProvider = self

            self.requestCompletion = { result, error in
                if let result = result {
                    observer(.success(result))
                } else {
                    observer(.failure(error ?? AppleLoginProviderError.unknown))
                }
            }

            self.authController?.performRequests()

            return Disposables.create {
                self.authController = nil
                self.requestCompletion = nil
            }
        }
    }

    public func checkCredential(appleIdToken: String) -> Single<CheckResult> {
        Single.create { [unowned self] observer -> Disposable in
            assert(Thread.isMainThread)

            self.appleIDProvider.getCredentialState(forUserID: appleIdToken) { state, error in
                switch state {
                case .revoked, .notFound:
                    observer(.success(.notFound(error)))
                case .authorized:
                    observer(.success(.authorized))
                case .transferred:
                    observer(.success(.notFound(error)))
                @unknown default:
                    observer(.success(.notFound(error)))
                }
            }

            return Disposables.create()
        }
    }
}

extension AppleLoginProvider: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // MARK: - ASAuthorizationControllerDelegate

    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            let userId = appleIDCredential.user
            let identityToken = appleIDCredential.identityToken?.base64EncodedString() ?? ""
            let authorizationCode = appleIDCredential.authorizationCode?.base64EncodedString() ?? ""

            let givenName: String?
            let familyName: String?

            if appleIDCredential.fullName?.givenName != nil, appleIDCredential.fullName?.familyName != nil {
                givenName = appleIDCredential.fullName?.givenName
                familyName = appleIDCredential.fullName?.familyName

                let fullName = (givenName ?? "_") + "=" + (familyName ?? "_")

                try? storage.setData(fullName.data(using: .utf8), forKey: userId)
            } else {
                if let data = try? storage.getData(forKey: userId) as? Data {
                    let fullName = String(data: data, encoding: .utf8)
                    let bits = fullName?.split(separator: "=") ?? []

                    givenName = String(bits.first ?? "_")
                    familyName = String(bits.last ?? "_")
                } else {
                    givenName = nil
                    familyName = nil
                }
            }

            let result = RequestResult(userId: userId,
                                       givenName: givenName,
                                       familyName: familyName,
                                       identityToken: identityToken,
                                       authCode: authorizationCode)

            requestCompletion?(result, nil)

        default:
            requestCompletion?(nil, AppleLoginProviderError.unknown)
            assertionFailure()
        }
    }

    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithError error: Error) {
        requestCompletion?(nil, error)
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let keyWindow = presentationContextDelegate?.presentationAnchor(for: controller) else {
            assertionFailure("You must provide a presentation anchor")
            return UIWindow()
        }

        return keyWindow
    }
}
