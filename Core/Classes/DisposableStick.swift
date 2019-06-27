import Foundation
import RxSwift

public final class DisposableStick {

    public init() {}

    public var disposable: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }

    deinit {
        disposable?.dispose()
    }
}
