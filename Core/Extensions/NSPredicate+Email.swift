import Foundation

public extension NSPredicate {

    static var emailPredicate: NSPredicate = {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    }()
}
