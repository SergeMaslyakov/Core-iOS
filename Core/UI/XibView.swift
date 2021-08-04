import UIKit

open class XibView: UIView {
    public var contentView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func xibSetup() {
        contentView = loadViewFromNib()

        contentView?.frame = bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView?.translatesAutoresizingMaskIntoConstraints = true

        if let view = contentView {
            addSubview(view)
        }
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }
}
