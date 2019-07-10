import UIKit

public extension UIView {

    static func loadFromXib() -> UIView? {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle(for: self))
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

    func setConstraintHeigh(_ value: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[view(\(value))]",
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

    func maskRoundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
        guard radius > 0 else { return }

        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath

        layer.mask = mask
    }

    func roundCorners(radius: CGFloat) {
        guard radius > 0 else { return }

        if #available(iOS 11, *) {
            layer.maskedCorners = []
        }

        clipsToBounds = true
        layer.cornerRadius = radius
    }

}
