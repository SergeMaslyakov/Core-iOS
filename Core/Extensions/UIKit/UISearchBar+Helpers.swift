import UIKit

public extension UISearchBar {

    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            return self.value(forKey: "searchField") as? UITextField
        }
    }

    var placeholderLabel: UILabel? {
        return textField?.value(forKey: "placeholderLabel") as? UILabel
    }
}
