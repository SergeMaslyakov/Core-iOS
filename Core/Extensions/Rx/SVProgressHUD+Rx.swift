import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

public extension Reactive where Base: SVProgressHUD {
    static var isAnimating: Binder<Bool> {
        Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }

    static var isBlockingAnimating: Binder<Bool> {
        Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
            } else {
                SVProgressHUD.setDefaultMaskType(.none)
                SVProgressHUD.dismiss()
            }
        }
    }
}
