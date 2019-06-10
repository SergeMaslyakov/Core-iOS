import Foundation

public enum BiometryType {
    case none, touchID, faceID
}

public protocol BiometricAuthService {

    var isPincodeStored: Bool { get }

    func obtainBiometryType() -> BiometryType
    func removePincode()
    func retrievePincode(completion: @escaping (_ result: Result<String?, Error>) -> Void)
    func storePincode(_ pincode: String) -> Result<Bool, Error>
}
