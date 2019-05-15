import UIKit

public extension UIImage {

    static func image(with color: UIColor, bounds: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        color.setFill()
        UIRectFill(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
