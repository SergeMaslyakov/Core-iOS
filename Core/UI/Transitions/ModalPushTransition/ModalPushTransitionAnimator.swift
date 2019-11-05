import UIKit

public final class ModalPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public var transitionDuration: TimeInterval = 0.6
    public var presenting: Bool = true

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let isAnimated = transitionContext?.isAnimated ?? false

        return isAnimated ? transitionDuration : 0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        let dX = presenting ? fromVC.view.frame.width : -fromVC.view.frame.width

        toVC.view.frame = fromVC.view.frame.offsetBy(dx: dX, dy: 0)
        let finalFrame = fromVC.view.frame.offsetBy(dx: -dX, dy: 0)

        if presenting {
            transitionContext.containerView.addSubview(toVC.view)
        }
        let duration = transitionContext.isAnimated ? transitionDuration : 0

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 4, options: [.curveEaseOut],
                       animations: {

            toVC.view.frame = fromVC.view.frame
            fromVC.view.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
