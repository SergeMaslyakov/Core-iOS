import Foundation

public enum AppError: Error {
    case unexpected
    case unexpectedWithUnderlying(Error)
    case unexpectedWithDescription(String)
    case reachabilityUnavailable

    case cantExportAssets
    case cantCreateQRCode
}
