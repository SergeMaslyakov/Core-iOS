import Foundation
import SwiftyBeaver

public final class SwiftyBeaverLogger: Logger {

    public init(destinations: [BaseDestination]) {
        destinations.forEach { SwiftyBeaver.addDestination($0) }
    }

    public func verbose(_ string: String) {
        SwiftyBeaver.verbose(string)
    }

    public func debug(_ string: String) {
        SwiftyBeaver.debug(string)
    }

    public func info(_ string: String) {
        SwiftyBeaver.info(string)
    }

    public func warning(_ string: String) {
        SwiftyBeaver.warning(string)
    }

    public func error(_ string: String) {
        SwiftyBeaver.error(string)
    }

    public func fatal(_ string: String) {
        SwiftyBeaver.error(string)
    }
}
