import Foundation

public final class PrintLogger: AppLoggerProtocol {
    public init() { }

    public func info(_ string: String) {
        print(string)
    }

    public func debug(_ string: String) {
        print(string)
    }

    public func warning(_ string: String) {
        print(string)
    }

    public func error(_ string: String) {
        print(string)
    }

    public func fatal(_ string: String) {
        print(string)
    }
}
