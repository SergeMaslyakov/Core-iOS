import Foundation

public enum TimeFormatter {

    /// string like 01:59:01
    public static func timeFrom(seconds: Int) -> String {

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

    /// hours from string looks like "HH:mm:ss"
    public static func hours(from str: String) -> Int? {
        let comp = str.components(separatedBy: ":")

        if let h = comp.first, h.isDigits {
            return Int(h)
        }

        return nil
    }

    /// minutes from string looks like "HH:mm"
    public static func minutes(from str: String) -> Int? {
        let comp = str.components(separatedBy: ":")

        if comp.count > 1, comp[1].isDigits {
            return Int(comp[1])
        }

        return nil
    }
}
