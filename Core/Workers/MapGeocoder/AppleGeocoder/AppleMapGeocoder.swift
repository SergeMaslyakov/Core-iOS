import Foundation
import CoreLocation

import RxSwift
import RxCocoa

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

    public func addressGeocoding(query: String, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]> {
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
                worker.geocodeAddressString(query, in: nil, preferredLocale: locale, completionHandler: completion)
            } else {
                worker.geocodeAddressString(query, completionHandler: completion)
            }

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }
}
