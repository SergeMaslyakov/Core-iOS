import Foundation
import SystemConfiguration

public enum ReachabilityStatus {
    case unknown
    case unreachable
    case wifi
    case cellular

    public static func make(from flags: SCNetworkReachabilityFlags) -> ReachabilityStatus {

        if !flags.contains(.reachable) {
            return .unreachable
        }

        if flags.contains(.isWWAN) {
            return .cellular
        }

        if !flags.contains(.connectionRequired) {
            return .wifi
        }

        if !flags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty && !flags.contains(.interventionRequired) {
            return .wifi
        }

        return .unknown
    }
}
