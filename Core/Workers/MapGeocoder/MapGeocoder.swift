import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public typealias MapGeocoderAddressExtractor = (Any) -> String?

public protocol MapGeocoder: class {

    func reverseGeocoding(by location: CLLocation, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]>

    func forwardGeocoding(place: String, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]>

    func addressSearch(query: String, box: MapGeoBox, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]>
}
