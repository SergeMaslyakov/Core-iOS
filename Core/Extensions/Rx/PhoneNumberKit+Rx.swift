import Foundation
import PhoneNumberKit
import RxSwift

public extension PhoneNumberKit {

    func validatePhoneNumber(_ number: String) -> Observable<Bool> {
        return Observable.deferred {
            do {
                _ = try self.parse(number)
                return .just(true)
            } catch {
                return .just(false)
            }

        }.subscribeOn(SerialRxScheduler.sharedBackground)
    }

}
