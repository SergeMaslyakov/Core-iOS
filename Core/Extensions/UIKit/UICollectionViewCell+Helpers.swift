import UIKit

public extension UICollectionViewCell {

    static func emptyCellWithAssert() -> UICollectionViewCell {
        assert(false, "Empty UICollectionViewCell")
        return UICollectionViewCell()
    }
}
