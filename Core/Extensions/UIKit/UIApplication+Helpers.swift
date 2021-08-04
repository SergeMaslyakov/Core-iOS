import UIKit

public extension UIApplication {
    var firstKeyWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
}
