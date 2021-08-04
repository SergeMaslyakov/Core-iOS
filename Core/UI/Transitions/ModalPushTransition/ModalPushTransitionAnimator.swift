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
        let vcT = transitionContext.viewController(forKey: .to)
        let vcF = transitionContext.viewController(forKey: .from)

        guard let fromVC = vcF, let toVC = vcT else {
            transitionContext.completeTransition(true)
            return
        }

        let width = fromVC.view.bounds.width

        var initialToFrame = toVC.view.frame
        var finalToFrame = toVC.view.frame

        initialToFrame.origin.x = presenting ? width : -(width / 3)
        finalToFrame.origin.x = 0

        toVC.view.frame = initialToFrame

        var initialFromFrame = fromVC.view.frame
        var finalFromFrame = fromVC.view.frame

        initialFromFrame.origin.x = 0
        finalFromFrame.origin.x = presenting ? -(width / 3) : width

        fromVC.view.frame = initialFromFrame

        var completion: (() -> Void)?

        if presenting {
            transitionContext.containerView.addSubview(toVC.view)
            completion = { [weak fromVC] in
                fromVC?.view.frame = initialFromFrame
            }
        }
        let duration = transitionContext.isAnimated ? transitionDuration : 0

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 4, options: [.curveEaseOut],
                       animations: {
                           toVC.view.frame = finalToFrame
                           fromVC.view.frame = finalFromFrame
                       }, completion: { _ in
                           completion?()
                           transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                       })
    }
}
