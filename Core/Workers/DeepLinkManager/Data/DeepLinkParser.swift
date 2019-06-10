import Foundation
import RxSwift

public protocol DeepLinkParser {
    func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func canHandle(_ url: URL) -> Bool
    func parse(_ url: URL, app: UIApplication, options: [UIApplication.OpenURLOptionsKey: Any]) -> Observable<DeepLinkType>
}
