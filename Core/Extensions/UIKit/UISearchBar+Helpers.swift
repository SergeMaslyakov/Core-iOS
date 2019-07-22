import UIKit

public extension UISearchBar {

    var textField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }

    var placeholderLabel: UILabel? {
        return textField?.value(forKey: "placeholderLabel") as? UILabel
    }
}
