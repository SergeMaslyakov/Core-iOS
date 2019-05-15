import Foundation

public struct AppVersion: Comparable {

    let major: Int
    let minor: Int
    let patch: Int

    // MARK: - Comparable

    public static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }

    public static func > (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major > rhs.major {
            return true
        } else if lhs.major >= rhs.major && lhs.minor > rhs.minor {
            return true
        } else if lhs.major >= rhs.major && lhs.minor >= rhs.minor && lhs.patch > rhs.patch {
            return true
        }

        return false
    }

    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        return rhs > lhs
    }

}

// MARK: - Factory

public extension AppVersion {

    static func makeFromString(_ string: String) -> AppVersion? {
        let components = string.components(separatedBy: ".")

        if components.count >= 2, let major = Int(components[0]), let minor = Int(components[1]) {
            let patch = components.count > 2 ? Int(components[2]) : 0
            return AppVersion(major: major, minor: minor, patch: patch ?? 0)
        }

        return nil
    }

    static func makeZeroVersion() -> AppVersion {
        return AppVersion(major: 0, minor: 0, patch: 0)
    }
}
