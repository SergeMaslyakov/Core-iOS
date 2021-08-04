import UIKit

public protocol ConfigurableCell {
    associatedtype T

    static var nib: UINib? { get }

    static var defaultHeight: CGFloat { get }
    static var reuseId: String { get }

    func configure(with _: T)
}

public extension ConfigurableCell where Self: UICollectionViewCell {
    static var nib: UINib? {
        UINib(nibName: reuseId, bundle: Bundle(for: self))
    }

    static var reuseId: String {
        String(describing: self)
    }

    static func registerNib(in collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseId)
    }

    static func registerClass(in collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseId)
    }
}

public extension ConfigurableCell where Self: UICollectionReusableView {
    static var nib: UINib? {
        UINib(nibName: reuseId, bundle: Bundle(for: self))
    }

    static var reuseId: String {
        String(describing: self)
    }

    static func registerNib(in collectionView: UICollectionView, forSupplementaryViewOfKind kind: String) {
        collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseId)
    }

    static func registerClass(in collectionView: UICollectionView) {
        collectionView.register(self, forSupplementaryViewOfKind: reuseId, withReuseIdentifier: reuseId)
    }
}

public extension ConfigurableCell where Self: UITableViewCell {
    static var nib: UINib? {
        UINib(nibName: reuseId, bundle: Bundle(for: self))
    }

    static var reuseId: String {
        String(describing: self)
    }

    static func registerNib(in tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }

    static func registerClass(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: reuseId)
    }
}
