import UIKit

public enum AttributedStringUtils {

    public static func makeTextLink(text: String, textLinkRange: NSRange?, font: UIFont, textColor: UIColor, linkColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [
                .font: font,
                .foregroundColor: textColor,
                .kern: -0.3
            ])

        let nsRange = textLinkRange ?? NSRange(location: 0, length: text.count)

        /// I don't want how to set the link color.
        //let link = text[Range(nsRange, in: text) ?? text.startIndex..<text.endIndex]
        //attributedString.addAttribute(.link, value: link, range: nsRange)
        attributedString.addAttribute(.foregroundColor, value: linkColor, range: nsRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        attributedString.addAttribute(.underlineColor, value: linkColor, range: nsRange)

        return NSAttributedString(attributedString: attributedString)
    }

}
