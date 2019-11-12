import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public typealias MapGeocoderAddressExtractor = (Any) -> String?
public typealias MapGeocoderFilter = (Any) -> Bool

public protocol MapGeocoder: class {

    func reverseGeocoding(by location: CLLocation,
                          filter: @escaping MapGeocoderFilter,
                          addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>

    func forwardGeocoding(place: String,
                          filter: @escaping MapGeocoderFilter,
                          addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>

    func addressSearch(query: String,
                       box: MapGeoBox,
                       filter: @escaping MapGeocoderFilter,
                       addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]>
}
