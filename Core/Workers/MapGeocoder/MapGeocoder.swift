import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public typealias MapGeocoderAddressExtractor = (Any) -> String?

public protocol MapGeocoder: class {

    func reverseGeocoding(by location: CLLocation, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]>

    func addressGeocoding(query: String, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]>
}
