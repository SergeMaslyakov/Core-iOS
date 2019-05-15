import UIKit

final public class AvatarImageView: UIImageView {

    public convenience init() {
        self.init(frame: CGRect.zero)
        clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        maskRoundCorners(radius: frame.width / 2)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        maskRoundCorners(radius: frame.width / 2)
    }

}
