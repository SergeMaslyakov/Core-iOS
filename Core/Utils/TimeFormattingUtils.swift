import Foundation

public enum TimeFormatter {

    /// string like 01:59:01
    static func timeFrom(seconds: Int) -> String {

        func stringify(value: Int) -> String {
            return value < 10 ? "0\(value)" : "\(value)"
        }

        let hrs = stringify(value: seconds / 3600)
        let mins = stringify(value: (seconds % 3600) / 60)
        let sesc = stringify(value: (seconds % 3600) % 60)

        if (seconds / 3600) > 0 {
            return "\(hrs):\(mins):\(sesc)"
        } else {
            return "\(mins):\(sesc)"
        }
    }
}
