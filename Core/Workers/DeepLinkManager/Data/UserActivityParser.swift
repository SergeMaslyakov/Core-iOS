import Foundation
import RxSwift

public protocol UserActivityParser {
    func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func parse(_ activity: NSUserActivity) -> Observable<DeepLinkType>
    func canHandle(_ activity: NSUserActivity) -> Bool
}

public extension UserActivityParser where Self: DeepLinkParser {
    func canHandle(_ activity: NSUserActivity) -> Bool {

        if activity.activityType == NSUserActivityTypeBrowsingWeb, let url = activity.webpageURL {
            return canHandle(url)
        } else {
            return false
        }
    }
}
