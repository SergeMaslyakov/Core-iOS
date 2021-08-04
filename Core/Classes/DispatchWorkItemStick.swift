import Foundation

public final class DispatchWorkItemStick {
    public init() { }

    private var _identifier: Int = 0

    public var identifier: Int {
        _identifier
    }

    public var item: DispatchWorkItem? {
        didSet {
            _identifier += 1
            oldValue?.cancel()
        }
    }

    public func checkThatItemIsValid(_ identifier: Int) -> Bool {
        guard _identifier == identifier else { return false }

        return item != nil && item?.isCancelled == false
    }

    deinit {
        item?.cancel()
    }
}
