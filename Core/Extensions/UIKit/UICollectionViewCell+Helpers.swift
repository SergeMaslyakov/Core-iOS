import UIKit

public extension UICollectionViewCell {
    static func emptyCellWithAssert() -> UICollectionViewCell {
        assertionFailure()
        return UICollectionViewCell()
    }
}
