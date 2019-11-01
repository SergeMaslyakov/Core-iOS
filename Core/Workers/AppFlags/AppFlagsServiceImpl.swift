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

    private let logger: Logger
    private let storage: DataStorageProtocol

    public init(storage: DataStorageProtocol, logger: Logger) {
        self.storage = storage
        self.logger = logger
    }

    // MARK: - AppFlagsService

    public var firstLaunchDate: Date? {
        do {
            if let ti = try storage.getData(forKey: Keys.firstLaunchDate.bundleRelatedKey) as? Double {
                return Date(timeIntervalSince1970: ti)
            }
        } catch {
            logger.error("AppFlagsService: error during fetching `FirstLaunchDate`")
        }

        return nil
    }

    public var initialVersion: String {
        do {
            if let version = try storage.getData(forKey: Keys.initialVersion.bundleRelatedKey) as? String {
                return version
            }
        } catch {
            logger.error("AppFlagsService: error during fetching `InitialVersion flag`")
        }

        return AppBundle.displayVersion
    }

    public var currentVersion: String {
        do {
            if let version = try storage.getData(forKey: Keys.currentVersion.bundleRelatedKey) as? String {
                return version
            }
        } catch {
            logger.error("AppFlagsService: error during fetching `CurrentVersion flag`")
        }

        return AppBundle.displayVersion
    }

    public func processAppUpdateIfNeeded(handler: ((NewVersionData) -> Void)?) {
        let version = currentVersion
        let isAppWasUpdated = version != AppBundle.displayVersion

        do {
            try storage.setData(AppBundle.displayVersion, forKey: Keys.currentVersion.bundleRelatedKey)
        } catch {
            logger.error("AppFlagsService: error during saving `CurrentVersion flag`")
        }

        if isAppWasUpdated {
            handler?(NewVersionData(initialVersion: version, newVersion: AppBundle.displayVersion))
        }
    }

    public func processFirstLaunchIfNeeded(handler: ((FirstLaunchData) -> Void)?) {
        let date = firstLaunchDate
        let isFirstLaunch = date == nil

        if isFirstLaunch {
            do {
                try storage.setData(Date().timeIntervalSince1970, forKey: Keys.firstLaunchDate.bundleRelatedKey)
                try storage.setData(AppBundle.displayVersion, forKey: Keys.initialVersion.bundleRelatedKey)
            } catch {
                logger.error("AppFlagsService: error during saving `FirstLaunchDate`")
            }
        }

        handler?(FirstLaunchData(isFirstLaunch: isFirstLaunch, firstLaunchDate: date))
    }
}
