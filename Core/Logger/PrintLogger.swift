import Foundation

public final class PrintLogger: Logger {

    public init() { }

    public func verbose(_ string: String) {
        print(string)
    }

    public func debug(_ string: String) {
        print(string)
    }

    public func info(_ string: String) {
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
