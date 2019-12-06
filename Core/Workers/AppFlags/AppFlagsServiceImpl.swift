import Foundation

public final class AppFlagsServiceImpl: AppFlagsService {

    private enum Keys: String {
        case firstLaunchDate = "app_first_launch_date"
        case initialVersion = "app_initial_version"
        case currentVersion = "app_current_version"

        var bundleRelatedKey: String {
            return AppBundle.bundleIdentifier + "." + self.rawValue
        }
    }

    private let storage: DataStorageProtocol

    public init(storage: DataStorageProtocol) {
        self.storage = storage
    }

    // MARK: - AppFlagsService

    public func retreiveFirstLaunchDate() throws -> Date? {
        let ti = try storage.getData(forKey: Keys.firstLaunchDate.bundleRelatedKey)

        if let ti = ti as? Double {
            return Date(timeIntervalSince1970: ti)
        }

        return nil
    }

    public func retreiveInitialVersion() throws -> String {
        let version = try storage.getData(forKey: Keys.initialVersion.bundleRelatedKey) as? String

        return version ?? AppBundle.displayVersion
    }

    public func retreiveCurrentVersion() throws -> String {
        let version = try storage.getData(forKey: Keys.currentVersion.bundleRelatedKey) as? String

        return version ?? AppBundle.displayVersion
    }

    public func processAppUpdateIfNeeded(handler: ((NewVersionData) -> Void)?) throws {
        let version = try retreiveCurrentVersion()
        let isAppWasUpdated = version != AppBundle.displayVersion

        try storage.setData(AppBundle.displayVersion, forKey: Keys.currentVersion.bundleRelatedKey)

        if isAppWasUpdated {
            handler?(NewVersionData(initialVersion: version, newVersion: AppBundle.displayVersion))
        }
    }

    public func processFirstLaunchIfNeeded(handler: ((FirstLaunchData) -> Void)?) throws {
        let date = try retreiveFirstLaunchDate()
        let isFirstLaunch = date == nil

        if isFirstLaunch {
            try storage.setData(Date().timeIntervalSince1970, forKey: Keys.firstLaunchDate.bundleRelatedKey)
            try storage.setData(AppBundle.displayVersion, forKey: Keys.initialVersion.bundleRelatedKey)
        }

        handler?(FirstLaunchData(isFirstLaunch: isFirstLaunch, firstLaunchDate: date))
    }
}
