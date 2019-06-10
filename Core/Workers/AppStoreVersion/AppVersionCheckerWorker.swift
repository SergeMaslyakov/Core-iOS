import Foundation
import RxSwift

public protocol AppVersionCheckerWorker: class {

    var onAppOutdated: Observable<Void> { get }

    func checkAppStoreVersionIfNeeded()
}
