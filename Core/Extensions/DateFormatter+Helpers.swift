import Foundation

public extension DateFormatter {

    static var iso8601: ISO8601DateFormatter = {
        return ISO8601DateFormatter()
    }()

}
