import Photos
import RxSwift
import UIKit

// Resizing utils copyright - https://github.com/gavinbunney/Toucan

public enum ImageUtils {
    public static func changeFileExtension(filename: String, to ext: String) -> String {
        var pieces = filename.split(separator: ".")

        guard pieces.count > 1, let last = pieces.last, last != ext else { return filename }

        _ = pieces.removeLast()
        let reassembledName = pieces.joined(separator: ".")
        return reassembledName + "." + ext
    }

    public static func convertToJpeg(_ data: Data, quality: CGFloat = 1.0) -> Single<Data> {
        Single.create { single -> Disposable in
            if let jpegData = UIImage(data: data)?.jpegData(compressionQuality: quality) {
                single(.success(jpegData))
            } else {
                single(.failure(NSError(domain: "core.image.utils",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "compression error"])))
            }

            return Disposables.create()
        }
    }

    public static func resize(image: UIImage, imageScalingSize: CGFloat) -> Single<UIImage> {
        Single.create { single -> Disposable in

            let originalSize = image.size

            if originalSize.height < imageScalingSize, originalSize.width < imageScalingSize {
                single(.success(image))
            } else {
                let ratio = imageScalingSize / max(originalSize.height, originalSize.width)
                let size = CGSize(width: originalSize.width * ratio, height: originalSize.height * ratio)

                if let resizedImage = ImageUtils.resize(image: image, byScaling: size) {
                    single(.success(resizedImage))
                } else {
                    single(.success(image))
                }
            }

            return Disposables.create()
        }
    }

    public static func resize(image: UIImage, byScaling size: CGSize) -> UIImage? {
        let imgRef = Utils.cgImageWithCorrectOrientation(image)
        let originalWidth = CGFloat(imgRef?.width ?? 0)
        let originalHeight = CGFloat(imgRef?.height ?? 0)
        let widthRatio = size.width / originalWidth
        let heightRatio = size.height / originalHeight

        let scaleRatio = max(heightRatio, widthRatio)
        let resizedBounds = CGRect(x: 0, y: 0, width: round(originalWidth * scaleRatio), height: round(originalHeight * scaleRatio))

        if let resizedImage = Utils.draw(image: image, in: resizedBounds, scale: image.scale) {
            return Utils.draw(image: resizedImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height), scale: resizedImage.scale)
        }

        return nil
    }

    public static func makeColoredImage(color: UIColor, bounds: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    public static func makeGradientImage(colors: [UIColor], points: [CGPoint], bounds: CGRect) -> UIImage {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors.map(\.cgColor)

        if points.count > 1 {
            layer.startPoint = points[0]
            layer.endPoint = points[1]
        } else if points.count == 1 {
            layer.startPoint = points[0]
        }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    public static func makeColoredRoundImage(color: UIColor, bounds: CGRect, cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        color.setFill()

        let maskPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: bounds.size), cornerRadius: cornerRadius)
        maskPath.addClip()
        UIRectFill(bounds)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    public static func scaleImage(_ image: UIImage, maxWidth width: CGFloat) -> UIImage {
        let currentSize = image.size
        let newSize = CGSize(width: width, height: currentSize.height * width / currentSize.width)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        let resultImage = renderer.image { _ in
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }

        return resultImage
    }

    public static func scaleImage(_ image: UIImage, maxHeight height: CGFloat) -> UIImage {
        let currentSize = image.size
        let newSize = CGSize(width: currentSize.width * height / currentSize.height, height: height)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        let resultImage = renderer.image { _ in
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }

        return resultImage
    }

    private enum Utils {
        // swiftlint:disable function_body_length superfluous_disable_command
        static func cgImageWithCorrectOrientation(_ image: UIImage) -> CGImage? {
            if image.imageOrientation == UIImage.Orientation.up {
                return image.cgImage
            }

            var transform = CGAffineTransform.identity

            switch image.imageOrientation {
            case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: image.size.height)
                transform = transform.rotated(by: .pi / -2.0)
            case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.rotated(by: .pi / 2.0)
            case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
                transform = transform.translatedBy(x: image.size.width, y: image.size.height)
                transform = transform.rotated(by: .pi)
            default:
                break
            }

            switch image.imageOrientation {
            case UIImage.Orientation.rightMirrored, UIImage.Orientation.leftMirrored:
                transform = transform.translatedBy(x: image.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case UIImage.Orientation.downMirrored, UIImage.Orientation.upMirrored:
                transform = transform.translatedBy(x: image.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            default:
                break
            }

            let contextWidth: Int
            let contextHeight: Int

            switch image.imageOrientation {
            case UIImage.Orientation.left, UIImage.Orientation.leftMirrored,
                 UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
                contextWidth = image.cgImage?.height ?? 0
                contextHeight = image.cgImage?.width ?? 0
            default:
                contextWidth = image.cgImage?.width ?? 0
                contextHeight = image.cgImage?.height ?? 0
            }

            let context = CGContext(data: nil, width: contextWidth, height: contextHeight,
                                    bitsPerComponent: image.cgImage?.bitsPerComponent ?? 0,
                                    bytesPerRow: 0,
                                    space: image.cgImage?.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                    bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!

            context.concatenate(transform)
            context.draw(image.cgImage!, in: CGRect(x: 0,
                                                    y: 0,
                                                    width: CGFloat(contextWidth),
                                                    height: CGFloat(contextHeight)))

            let cgImage = context.makeImage()
            return cgImage
        }

        // swiftlint:enable function_body_length superfluous_disable_command

        static func draw(image: UIImage, in bounds: CGRect, scale: CGFloat) -> UIImage? {
            guard bounds.width > 0.0, bounds.height > 0.0 else {
                debugPrint("Resize UIImage - wrong params")
                return nil
            }

            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)

            image.draw(in: bounds)
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            return scaledImage
        }
    }
}
