import UIKit

public final class ModalFadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var transitionDuration: TimeInterval = 0.25
    public var presenting: Bool = true

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let isAnimated = transitionContext?.isAnimated ?? false

        return isAnimated ? transitionDuration : 0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)

        guard let finalView = presenting ? toView : fromView else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)

        fromVC?.beginAppearanceTransition(false, animated: transitionContext.isAnimated)
        toVC?.beginAppearanceTransition(true, animated: transitionContext.isAnimated)

        let initialAlpha: CGFloat = presenting ? 0 : 1
        let finalAlpha: CGFloat = presenting ? 1 : 0

        finalView.alpha = initialAlpha

        if presenting {
            transitionContext.containerView.addSubview(finalView)
        }

        UIView.animate(withDuration: transitionDuration, animations: {
            finalView.alpha = finalAlpha
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            fromVC?.endAppearanceTransition()
            toVC?.endAppearanceTransition()
        })
    }
}
