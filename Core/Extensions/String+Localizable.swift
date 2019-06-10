import Foundation

public extension String {

    func localizable(_ file: String? = nil) -> String {
        return NSLocalizedString(self, tableName: file, bundle: .main, value: "", comment: "")
    }

    func pluralForm(_ args: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, locale: .current, arguments: args)
    }

    var isAlphanumerics: Bool {
        return rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && !isEmpty
    }

    var isDigits: Bool {
        return rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil && !isEmpty
    }
}
