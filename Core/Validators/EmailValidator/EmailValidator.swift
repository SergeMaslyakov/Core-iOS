import Foundation
import RxSwift

public protocol EmailValidator {
    func validateRx(_ email: String) -> Observable<Bool>
    func validate(_ email: String) -> Bool
}
