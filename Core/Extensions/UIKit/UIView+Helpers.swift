import UIKit

public extension UIView {

    static func loadFromXib(_ name: String? = nil, _ bundle: Bundle? = nil) -> UIView? {
        let nib = UINib(nibName: name ?? String(describing: self), bundle: bundle ?? Bundle(for: self))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }

    func pinEdgesToSuperviewEdges(_ insets: UIEdgeInsets = .zero) {
        guard let superView = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-\(insets.left)-[view]-\(insets.right)-|",
            options: [],
            metrics: nil,
            views: ["view": self]))

        superView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(insets.top)-[view]-\(insets.bottom)-|",
            options: [],
            metrics: nil,
            views: ["view": self]))

        superView.layoutIfNeeded()
    }

    func addHeightConstraint(_ value: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(\(value))]",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["view": self]))
    }

    func addWidthConstraint(_ value: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(\(value))]",
            options: [],
            metrics: nil,
            views: ["view": self]))
    }

    func snapshotImage(in frame: CGRect? = nil) -> UIImage? {
        let bounds = frame ?? self.bounds
        let renderer = UIGraphicsImageRenderer(size: bounds.size)

        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }

    func applyRasterization() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func maskRoundCorners(radius: CGFloat) {
        guard radius > 0 else { return }

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)

        let mask = CAShapeLayer()
        mask.borderWidth = 1
        mask.borderColor = UIColor.black.withAlphaComponent(1).cgColor

        mask.path = path.cgPath

        layer.mask = mask
    }

    func roundCorners(radius: CGFloat) {
        guard radius > 0 else { return }

        layer.maskedCorners = []

        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.width * point.x, y: bounds.height * point.y)
        var oldPoint = CGPoint(x: bounds.width * layer.anchorPoint.x, y: bounds.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }

}
