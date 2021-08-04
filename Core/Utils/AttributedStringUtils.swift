import UIKit

public enum AttributedStringUtils {
    public static func makeTextLink(text: String, textLinkRange: [NSRange], font: UIFont, textColor: UIColor, linkColor: UIColor) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4

        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ])

        let ranges = textLinkRange.isEmpty ? [NSRange(location: 0, length: text.count)] : textLinkRange

        ranges.forEach { range in
            /// I don't know how to set the link color..
            // let link = text[Range(nsRange, in: text) ?? text.startIndex..<text.endIndex]
            // attributedString.addAttribute(.link, value: link, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: linkColor, range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedString.addAttribute(.underlineColor, value: linkColor, range: range)
        }

        return NSAttributedString(attributedString: attributedString)
    }
}
