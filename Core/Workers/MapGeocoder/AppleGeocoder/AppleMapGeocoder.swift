import MapKit

import RxCocoa
import RxSwift

public extension MapGeoBox {
    func toRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
}

public final class AppleMapGeocoder: MapGeocoder {
    public var prefferedLocale: Locale?

    public init() { }

    // MARK: - MapGeocoder

    public func reverseGeocoding(by location: CLLocation,
                                 filter: @escaping MapGeocoderFilter,
                                 addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]> {
        Single.create { [locale = prefferedLocale] single -> Disposable in

            let worker = CLGeocoder()
            let completion: CLGeocodeCompletionHandler = { placemarks, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    if let placemarks = placemarks, !placemarks.isEmpty {
                        let data = placemarks.lazy
                            .filter { filter($0) }
                            .compactMap { MapGeocodingData(placemark: $0, addressExtractor: addressExtractor) }
                        single(.success(Array(data)))
                    } else {
                        single(.success([]))
                    }
                }
            }

            worker.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: completion)

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }

    public func forwardGeocoding(place: String,
                                 filter: @escaping MapGeocoderFilter,
                                 addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]> {
        Single.create { [locale = prefferedLocale] single -> Disposable in

            let worker = CLGeocoder()
            let completion: CLGeocodeCompletionHandler = { placemarks, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    if let placemarks = placemarks, !placemarks.isEmpty {
                        let data = placemarks.lazy
                            .filter { filter($0) }
                            .compactMap { MapGeocodingData(placemark: $0, addressExtractor: addressExtractor) }
                        single(.success(Array(data)))
                    } else {
                        single(.success([]))
                    }
                }
            }

            worker.geocodeAddressString(place, in: nil, preferredLocale: locale, completionHandler: completion)

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }

    public func addressSearch(query: String,
                              box: MapGeoBox,
                              filter: @escaping MapGeocoderFilter,
                              addressExtractor: MapGeocoderAddressExtractor?) -> Single<[MapGeocodingData]> {
        Single.create { single -> Disposable in

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = box.toRegion()

            let worker = MKLocalSearch(request: request)

            let completion: MKLocalSearch.CompletionHandler = { response, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    if let response = response {
                        let items = response.mapItems
                        let data = items
                            .lazy
                            .filter { filter($0) }
                            .compactMap { MapGeocodingData(mapItem: $0, addressExtractor: addressExtractor) }

                        single(.success(Array(data)))
                    } else {
                        single(.success([]))
                    }
                }
            }

            worker.start(completionHandler: completion)

            return Disposables.create {
                worker.cancel()
            }
        }
    }
}
