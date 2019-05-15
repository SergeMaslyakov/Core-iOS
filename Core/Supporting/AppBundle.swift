import Foundation

public enum AppBundle {

    public static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "Unknown"
    }

    public static var name: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "Unknown"
    }

    public static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }

    public static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "Unknown"
    }

    public static var displayVersion: String {
        return AppBundle.version + "." + AppBundle.build
    }
}
