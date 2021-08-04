import UIKit

public extension UITableViewCell {
    static func emptyCellWithAssert() -> UITableViewCell {
        assertionFailure("Empty UITableViewCell")
        return UITableViewCell()
    }
}
