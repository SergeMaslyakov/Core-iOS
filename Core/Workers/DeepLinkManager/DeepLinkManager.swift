import UIKit

public protocol DeepLinkManager: class {

    func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

    func canHandleDeepLink(_ url: URL) -> Bool
    func canHandleUserActivity(_ userActivity: NSUserActivity) -> Bool

    func handleDeepLink(_ url: URL, app: UIApplication, options: [UIApplication.OpenURLOptionsKey: Any])
    func handleUserActivity(_ userActivity: NSUserActivity)
}
