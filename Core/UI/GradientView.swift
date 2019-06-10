import UIKit

public class GradientView: PassthroughView {

    public var startColor: UIColor = .init(white: 1, alpha: 0.1) {
        didSet { updateColors() }
    }

    public var endColor: UIColor = .init(white: 0.5, alpha: 0.3) {
        didSet { updateColors() }
    }

    public var startLocation: Double = 0.05 {
        didSet { updateLocations() }
    }

    public var endLocation: Double = 0.95 {
        didSet { updateLocations() }
    }

    public var horizontalMode: Bool = false {
        didSet { updatePoints() }
    }

    public var diagonalMode: Bool = false {
        didSet { updatePoints() }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        updatePoints()
        updateLocations()
        updateColors()
    }

    private var gradientLayer: CAGradientLayer {
        // swiftlint:disable force_cast
        return layer as! CAGradientLayer
        // swiftlint:enable force_cast
    }

    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }

    private func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }

    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

}
