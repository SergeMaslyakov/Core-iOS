import Foundation

public enum BiometryType {
    case none, touchID, faceID
}

public protocol BiometricAuthService {

    var isPincodeStored: Bool { get }

    func obtainBiometryType() -> BiometryType
    func removePincode()
    func retrievePincode(completion: @escaping (_ pincode: String?, _ error: Error?) -> Void)
    func storePincode(pincode: String, completion: ((_ success: Bool, _ error: Error?) -> Void)?)

}
