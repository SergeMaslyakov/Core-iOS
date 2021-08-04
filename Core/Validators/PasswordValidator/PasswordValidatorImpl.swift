import Foundation
import RxSwift

public final class PasswordValidatorImpl: PasswordValidator {
    private let minLength: Int
    private let maxLength: Int

    public init(minLength: Int, maxLength: Int) {
        self.minLength = minLength
        self.maxLength = maxLength
    }

    public func validateRx(_ password1: String, _ password2: String) -> Observable<PasswordValidatorResult> {
        Observable.deferred { [unowned self] in
            .just(self.validate(password1, password2))
        }
    }

    public func validate(_ password1: String, _ password2: String) -> PasswordValidatorResult {
        if password1.count < minLength {
            return .firstIsTooShort
        }

        if password1.count > maxLength {
            return .firstIsTooLong
        }

        if password2.count < minLength {
            return .secondIsTooShort
        }

        if password2.count > maxLength {
            return .secondIsTooLong
        }

        if password1 != password2 {
            return .invalidComparing
        }

        return .valid
    }
}
