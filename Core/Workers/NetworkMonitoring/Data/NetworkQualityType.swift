import Foundation

public enum NetworkQualityType {
    case unknown
    case good(ReachabilityStatus)
    case average
    case bad

    public static func make(fromRadio radio: RadioTechnologyType, andReachability reachability: ReachabilityStatus) -> NetworkQualityType {
        switch reachability {
        case .unknown, .unreachable:
            return .unknown
        case .wifi:
            return .good(.wifi)
        case .cellular:
            switch radio {
            case .unknown:
                return .unknown
            case .LTE:
                return .good(.cellular)
            case .r3G:
                return .average
            case .r2G:
                return .bad
            }
        }
    }
}
