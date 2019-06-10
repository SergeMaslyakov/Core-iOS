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

    public func retrievePincode(completion: @escaping (_ pincode: String?, _ error: Error?) -> Void) {
        var authError: NSError?

        if biometricContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            biometricContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                            localizedReason: touchIDMessage) { success, error in
                                                // FYI: It's a background thread
                                                if success {
                                                    let data = try? self.securedStorage.getData(forKey: self.pincodeKey)
                                                    var pincode: String?

                                                    if let data = data as? Data {
                                                        pincode = String(data: data, encoding: .utf8)
                                                    }

                                                    DispatchQueue.main.async {
                                                        completion(pincode, nil)
                                                    }
                                                } else {
                                                    DispatchQueue.main.async {
                                                        completion(nil, error)
                                                    }
                                                }
            }
        } else {
            DispatchQueue.main.async {
                completion(nil, authError)
            }
        }
    }

    public func storePincode(pincode: String, completion: ((_ success: Bool, _ error: Error?) -> Void)?) {
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
            completion?(true, nil)
        } catch {
            markPincodeAsStored(false)
            completion?(false, error)
        }
    }

}
