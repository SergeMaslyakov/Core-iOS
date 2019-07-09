import UIKit

public extension UIViewController {

    static func loadFromXib(bundle: Bundle? = nil, overriddenXib: String? = nil) -> Self {
        let identifier = String(describing: self)
        return self.init(nibName: overriddenXib ?? identifier, bundle: bundle)
    }

    static func loadFromStoryboard(_ name: String? = nil, id: String? = nil, bundle: Bundle? = nil) -> UIViewController {
        let identifier = String(describing: self)
        let id = id ?? identifier
        let storyboard = name ?? identifier.replacingOccurrences(of: "ViewController", with: "")

        return UIStoryboard(name: storyboard, bundle: bundle).instantiateViewController(withIdentifier: id)
    }

    static func emptyViewControllerWithAssert() -> UIViewController {
        assertionFailure()
        return UIViewController()
    }

    static func findVisibleController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController

        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }

        return topController
    }

    // MARK: - Embedding

    func embed(controller: UIViewController, inContainer container: UIView, insets: UIEdgeInsets = .zero) {

        addChild(controller)

        controller.view.frame = container.frame
        container.addSubview(controller.view)
        controller.view.pinEdgesToSuperviewEdges(insets)
        controller.didMove(toParent: self)
    }

    func remove(embeddedController controller: UIViewController?, then completion: (() -> Void)? = nil) {
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()

        completion?()
    }

}
