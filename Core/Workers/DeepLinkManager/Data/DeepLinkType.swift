import Foundation

public enum DeepLinkType {
    case unknown
    case deepLink(Any)

    var isUnknownDeepLink: Bool {
        switch self {
        case .unknown: return true
        default: return false
        }
    }
}
