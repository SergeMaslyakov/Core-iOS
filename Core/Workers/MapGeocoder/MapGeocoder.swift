import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public typealias MapGeocoderAddressExtractor = (Any) -> String?

public protocol MapGeocoder: class {

    func reverseGeocoding(by location: CLLocation, addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>

    func forwardGeocoding(place: String, addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>

    func addressSearch(query: String, box: MapGeoBox, addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>
}
