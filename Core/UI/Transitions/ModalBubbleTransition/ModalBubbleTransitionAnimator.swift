import UIKit

public protocol ModalBubbleTransitionAnimatorDelegate: AnyObject {
    func originPointForBubbleAnimation(_ animator: ModalBubbleTransitionAnimator) -> CGPoint
}

public final class ModalBubbleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    public var transitionDuration: TimeInterval = 0.4
    public var presenting: Bool = true

    public weak var delegate: ModalBubbleTransitionAnimatorDelegate?

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let isAnimated = transitionContext?.isAnimated ?? false
        return isAnimated ? 0 : transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        /// retain a reference on context
        self.transitionContext = transitionContext

        if presenting {
            transitionContext.containerView.addSubview(toVC.view)
        }

        animate(view: presenting ? toVC.view : fromVC.view, presenting: presenting)
    }

    // MARK: - CAAnimationDelegate

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = transitionContext {
            self.transitionContext = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    // MARK: - Private

    private var transitionContext: UIViewControllerContextTransitioning?

    private func animate(view: UIView, presenting: Bool) {
        let origin = delegate?.originPointForBubbleAnimation(self) ?? .zero

        let viewHeight = view.bounds.height
        let viewWidth = view.bounds.height

        let originX = origin.x < viewWidth / 2 ? viewWidth : -viewWidth
        let originY = origin.y < viewHeight / 2 ? viewHeight : -viewHeight

        let extremePoint = CGPoint(x: originX, y: originY)
        let radius = sqrt(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y)

        let originRect = CGRect(origin: origin, size: CGSize(width: 1, height: 1))
        let finalPath = UIBezierPath(ovalIn: originRect.insetBy(dx: -radius, dy: -radius))

        let rect = CGRect(origin: origin, size: CGSize(width: 0, height: 0))
        let initialPath = UIBezierPath(ovalIn: rect)

        /// Actual mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = presenting ? finalPath.cgPath : initialPath.cgPath
        view.layer.mask = maskLayer

        /// Mask Animation
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = presenting ? initialPath.cgPath : finalPath.cgPath
        maskLayerAnimation.toValue = presenting ? finalPath.cgPath : initialPath.cgPath
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        maskLayerAnimation.duration = transitionDuration
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}
