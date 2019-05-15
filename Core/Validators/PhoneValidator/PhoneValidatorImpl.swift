import Foundation
import PhoneNumberKit
import RxSwift

public final class PhoneValidatorImpl: PhoneValidator {

    private let phoneNumberKit: PhoneNumberKit

    public init(phoneNumberKit: PhoneNumberKit = PhoneNumberKit()) {
        self.phoneNumberKit = phoneNumberKit
    }

    public func validateRx(_ phone: String) -> Observable<Bool> {
        return phoneNumberKit.validatePhoneNumber(phone)
    }

    public func validate(_ phone: String) -> Bool {
        do {
            _ = try phoneNumberKit.parse(phone)
            return true
        } catch {
            return false
        }
    }

}
