import UIKit
import LocalAuthentication

public final class BiometricAuthServiceImpl: BiometricAuthService {

    private lazy var biometricContext: LAContext = LAContext()

    private let unsecuredStorage: DataStorageProtocol
    private let securedStorage: DataStorageProtocol

    private let touchIDMessage: String

    public init(unsecuredStorage: DataStorageProtocol, securedStorage: DataStorageProtocol, touchIDMessage: String) {
        self.unsecuredStorage = unsecuredStorage
        self.securedStorage = securedStorage
        self.touchIDMessage = touchIDMessage
    }

    // MARK: - Private

    private var pincodeKey: String {
        return "keychain.pincode." + AppBundle.bundleIdentifier
    }

    private func markPincodeAsStored(_ success: Bool) {
        do {
            try unsecuredStorage.setData(success, forKey: pincodeKey)
        } catch {
            print(error)
        }
    }

    // MARK: - BiometricAuthService

    public func obtainBiometryType() -> BiometryType {
        let available = biometricContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

        if available {
            if #available(iOS 11.0, *) {
                return biometricContext.biometryType == .touchID ? .touchID : .faceID
            } else {
                return .touchID
            }
        }

        return .none
    }

    public var isPincodeStored: Bool {
        do {
            return try unsecuredStorage.getData(forKey: pincodeKey) as? Bool ?? false
        } catch {
            return false
        }
    }

    public func removePincode() {
        do {
            _ = try securedStorage.removeData(forKey: pincodeKey)
            markPincodeAsStored(false)
        } catch {
            debugPrint(error)
        }

    }

    public func retrievePincode(completion: @escaping (_ result: Result<String?, Error>) -> Void) {
        var authError: NSError?

        if biometricContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            biometricContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                            localizedReason: touchIDMessage) { success, error in
                                                // FYI: It's a background thread
                                                if success {
                                                    do {
                                                        let data = try self.securedStorage.getData(forKey: self.pincodeKey)
                                                        var pincode: String?

                                                        if let data = data as? Data {
                                                            pincode = String(data: data, encoding: .utf8)
                                                        }

                                                        DispatchQueue.main.async {
                                                            completion(.success(pincode))
                                                        }
                                                    } catch {
                                                        DispatchQueue.main.async {
                                                            completion(.failure(error))
                                                        }
                                                    }
                                                } else {
                                                    DispatchQueue.main.async {
                                                        if let err = error {
                                                            completion(.failure(err))
                                                        } else {
                                                            completion(.success(nil))
                                                        }
                                                    }
                                                }
            }
        } else {
            DispatchQueue.main.async {
                if let err = authError {
                    completion(.failure(err))
                } else {
                    completion(.success(nil))
                }
            }
        }
    }

    public func storePincode(_ pincode: String) -> Result<Bool, Error> {
        let data = pincode.data(using: .utf8)

        do {
            if isPincodeStored {
                // update
                try securedStorage.updateData(data, forKey: pincodeKey)
            } else {
                // remove a previous value
                _ = try securedStorage.removeData(forKey: pincodeKey)

                // create a new
                try securedStorage.setData(data, forKey: pincodeKey)
            }

            markPincodeAsStored(true)
            return .success(true)
        } catch {
            markPincodeAsStored(false)
            return .failure(error)
        }
    }

}
