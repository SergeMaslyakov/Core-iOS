import Foundation

public struct AppStoreVersionModel: Codable {

    let version: String
    let currentVersionReleaseDate: String

    public init(version: String, currentVersionReleaseDate: String) {
        self.version = version
        self.currentVersionReleaseDate = currentVersionReleaseDate
    }

}

// MARK: - Helpers

public extension AppStoreVersionModel {

    static func makeZeroVersion() -> AppStoreVersionModel {
        return AppStoreVersionModel(version: "0.0.0",
                                    currentVersionReleaseDate: DateFormatter.iso8601.string(from: .distantFuture))
    }

    var releaseDate: Date? {
        return DateFormatter.iso8601.date(from: currentVersionReleaseDate)
    }
}
