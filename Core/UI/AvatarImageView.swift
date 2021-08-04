import UIKit

public final class AvatarImageView: UIImageView {
    public let label = UILabel(frame: .zero)

    public convenience init() {
        self.init(frame: CGRect.zero)

        addSubview(label)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubview(label)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        maskRoundCorners(radius: frame.width / 2)
        label.frame = CGRect(origin: .init(x: 5, y: 5),
                             size: .init(width: bounds.width - 10,
                                         height: bounds.height - 10))
    }
}
