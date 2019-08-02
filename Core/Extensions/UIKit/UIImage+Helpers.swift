import UIKit

public extension UIImage {

    static func image(with color: UIColor, bounds: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func roundedImage(cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        let maskPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        maskPath.addClip()

        draw(in: CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    func merge(foregroundImage: UIImage, at point: CGPoint) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        draw(at: .zero)
        foregroundImage.draw(at: point)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

}
