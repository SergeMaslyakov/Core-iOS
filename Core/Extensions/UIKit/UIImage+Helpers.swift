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

    func roundedImage(cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let maskPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        maskPath.addClip()

        draw(in: CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
