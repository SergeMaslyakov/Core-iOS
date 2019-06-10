import Foundation
import RxSwift

public protocol AppStoreVersionAPI: class {
    func appStoreVersion() -> Observable<AppStoreVersionModel>
}
