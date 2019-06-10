import Foundation

extension HTTPURLResponse {

    var containsJSONContent: Bool {
        if let headers = allHeaderFields as? [String: String] {
            if let value = headers["Content-Type"] {
                return value.contains("application/json")
            }
        }

        return false
    }

    var containsXWWWFormContent: Bool {
        if let headers = allHeaderFields as? [String: String] {
            if let value = headers["Content-Type"] {
                return value.contains("x-www-form-urlencoded")
            }
        }

        return false
    }

    var containsTextContent: Bool {
        if let headers = allHeaderFields as? [String: String] {
            if let value = headers["Content-Type"] {
                return value.contains("text")
            }
        }

        return false
    }
}
