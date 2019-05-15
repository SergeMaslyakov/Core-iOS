import Foundation
import RxSwift

public final class EmailValidatorImpl: EmailValidator {

    public init() {}

    public func validateRx(_ email: String) -> Observable<Bool> {
        return Observable.deferred {
            return .just(NSPredicate.emailPredicate.evaluate(with: email))
        }
    }

    public func validate(_ email: String) -> Bool {
        return NSPredicate.emailPredicate.evaluate(with: email)
    }

}
