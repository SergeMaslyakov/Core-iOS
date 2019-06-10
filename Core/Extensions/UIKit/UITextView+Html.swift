import UIKit

public extension UITextView {

    func show(html: String) {
        let font = UIFont.systemFont(ofSize: 16)
        let modifiedHtml = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize)\">\(html)</span>"

        if let htmlData = modifiedHtml.data(using: .unicode) {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {

                linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black]
                attributedText = attributedString
            }
        } else {
            text = html
        }
    }
}
