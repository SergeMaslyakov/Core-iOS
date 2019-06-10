import Foundation
import RxSwift

public protocol PhoneValidator {
    func validateRx(_ phone: String) -> Observable<Bool>
    func validate(_ phone: String) -> Bool
}
