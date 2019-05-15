import UIKit

public extension UITableViewCell {

    static func emptyCellWithAssert() -> UITableViewCell {
        assert(false, "Empty UITableViewCell")
        return UITableViewCell()
    }
}
