import Foundation

public enum AppBundle {
    public static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "Unknown"
    }

    public static var name: String {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "Unknown"
    }

    public static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    }

    public static var build: String {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "Unknown"
    }

    public static var displayVersion: String {
        AppBundle.version + "." + AppBundle.build
    }
}
