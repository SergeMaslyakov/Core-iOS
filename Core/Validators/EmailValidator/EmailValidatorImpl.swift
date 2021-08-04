import Foundation
import RxSwift

public final class EmailValidatorImpl: EmailValidator {
    public init() { }

    public func validateRx(_ email: String) -> Observable<Bool> {
        Observable.deferred {
            .just(NSPredicate.emailPredicate.evaluate(with: email))
        }
    }

    public func validate(_ email: String) -> Bool {
        NSPredicate.emailPredicate.evaluate(with: email)
    }
}
