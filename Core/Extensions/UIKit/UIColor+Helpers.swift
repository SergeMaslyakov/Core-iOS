import UIKit

public extension UIColor {
    convenience init?(_ hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count == 6 {
            self.init(cString, alpha: 1)
            return
        }

        guard cString.count == 8 else { return nil }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF00_0000) >> 24) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF_0000) >> 16) / 255.0,
                  blue: CGFloat((rgbValue & 0x0000_FF00) >> 8) / 255.0,
                  alpha: CGFloat(rgbValue & 0x0000_00FF) / 255.0)
    }

    convenience init?(_ hexString: String, alpha: CGFloat = 1) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        guard cString.count == 6 else { return nil }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
