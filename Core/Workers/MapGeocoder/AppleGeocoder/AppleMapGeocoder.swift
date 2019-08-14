import Foundation
import CoreLocation
import MapKit

import RxSwift
import RxCocoa

extension MapGeoBox {
    func toRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
}

public final class AppleMapGeocoder: MapGeocoder {

    public var prefferedLocale: Locale?

    public init() {}

    // MARK: - MapGeocoder

    public func reverseGeocoding(by location: CLLocation, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]> {
        return Observable.create { [locale = prefferedLocale] observer -> Disposable in

            let worker = CLGeocoder()
            let completion: CLGeocodeCompletionHandler = { placemarks, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let placemarks = placemarks, !placemarks.isEmpty {
                        observer.onNext(placemarks.compactMap { MapGeocodingData(placemark: $0, addressExtractor: addressExtractor) })
                    } else {
                        observer.onNext([])
                    }

                    observer.onCompleted()
                }
            }

            if #available(iOS 11.0, *) {
                worker.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: completion)
            } else {
                worker.reverseGeocodeLocation(location, completionHandler: completion)
            }

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }

    public func forwardGeocoding(place: String, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]> {
        return Observable.create { [locale = prefferedLocale] observer -> Disposable in

            let worker = CLGeocoder()
            let completion: CLGeocodeCompletionHandler = { placemarks, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let placemarks = placemarks, !placemarks.isEmpty {
                        observer.onNext(placemarks.compactMap { MapGeocodingData(placemark: $0, addressExtractor: addressExtractor) })
                    } else {
                        observer.onNext([])
                    }

                    observer.onCompleted()
                }
            }

            if #available(iOS 11.0, *) {
                worker.geocodeAddressString(place, in: nil, preferredLocale: locale, completionHandler: completion)
            } else {
                worker.geocodeAddressString(place, completionHandler: completion)
            }

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }

    public func addressSearch(query: String, box: MapGeoBox, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]> {
        return Observable.create { observer -> Disposable in

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = box.toRegion()

            let worker = MKLocalSearch(request: request)

            let completion: MKLocalSearch.CompletionHandler = { response, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let response = response {
                        let items = response.mapItems
                        observer.onNext(items.compactMap { MapGeocodingData(mapItem: $0, addressExtractor: addressExtractor) })
                    } else {
                        observer.onNext([])
                    }

                    observer.onCompleted()
                }
            }

            worker.start(completionHandler: completion)

            return Disposables.create {
                worker.cancel()
            }
        }

    }
}