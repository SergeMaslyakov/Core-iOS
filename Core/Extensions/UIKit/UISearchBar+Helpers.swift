import UIKit

public extension UISearchBar {
    var textField: UITextField? {
        searchTextField
    }

    var placeholderLabel: UILabel? {
        textField?.value(forKey: "placeholderLabel") as? UILabel
    }
}
