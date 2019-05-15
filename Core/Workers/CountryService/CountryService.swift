import Foundation
import RxSwift

public protocol CountryService {

    var countries: Observable<[CountryModel]> { get }
}
