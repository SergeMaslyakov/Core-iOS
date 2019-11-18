import Foundation

public enum NetworkQualityType: Equatable {
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

    // MARK: - Equatable

    public static func == (lhs: NetworkQualityType, rhs: NetworkQualityType) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown): return true
        case (.average, .average): return true
        case (.bad, .bad): return true
        case (.good(let s1), .good(let s2)): return s1 == s2
        default: return false
        }
    }

}
