import Foundation
import RxSwift

public protocol DeepLinkHandler {
    func canHandle(_ deepLink: DeepLinkType) -> Bool
    func handle(_ deepLink: DeepLinkType) -> Observable<Void>
}
