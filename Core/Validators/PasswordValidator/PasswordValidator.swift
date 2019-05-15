import Foundation
import RxSwift

public enum PasswordValidatorResult {
    case firstIsTooShort
    case secondIsTooShort
    case firstIsTooLong
    case secondIsTooLong
    case invalidComparing
    case valid

    public var hasWrongLength: Bool {
        switch self {
        case .firstIsTooShort, .secondIsTooShort, .firstIsTooLong, .secondIsTooLong: return true
        default: return false
        }
    }
}

public protocol PasswordValidator {
    func validateRx(_ password1: String, _ password2: String) -> Observable<PasswordValidatorResult>
    func validate(_ password1: String, _ password2: String) -> PasswordValidatorResult
}
