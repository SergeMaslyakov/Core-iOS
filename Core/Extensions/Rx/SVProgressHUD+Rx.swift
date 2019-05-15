import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

public extension Reactive where Base: SVProgressHUD {

    static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }

    static var isBlockingAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
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
