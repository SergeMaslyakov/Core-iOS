import Foundation
import CoreTelephony

public enum RadioTechnologyType {
    case unknown
    case LTE
    case r3G
    case r2G

    public static func make(from str: String) -> RadioTechnologyType {
        switch str {
        case CTRadioAccessTechnologyLTE,
             CTRadioAccessTechnologyHSDPA:
            return .LTE
        case CTRadioAccessTechnologyeHRPD,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB:
            return .r3G
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyCDMA1x,
             CTRadioAccessTechnologyEdge:
            return .r2G
        default:
            return .unknown
        }
    }
}
