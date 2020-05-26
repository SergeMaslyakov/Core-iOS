import Foundation
import Logging

public final class AppleSwiftLogger: AppLoggerProtocol {

    private let logger: Logging.Logger

    public init(label: String) {
        self.logger = Logger(label: label)
    }

    public func info(_ string: String) {
        logger.info(Logger.Message(stringLiteral: string))
    }

    public func debug(_ string: String) {
        logger.debug(Logger.Message(stringLiteral: string))
    }

    public func warning(_ string: String) {
        logger.warning(Logger.Message(stringLiteral: string))
    }

    public func error(_ string: String) {
        logger.error(Logger.Message(stringLiteral: string))
    }

    public func fatal(_ string: String) {
        logger.critical(Logger.Message(stringLiteral: string))
    }
}
