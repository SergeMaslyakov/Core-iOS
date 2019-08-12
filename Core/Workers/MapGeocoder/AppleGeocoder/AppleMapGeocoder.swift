import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public final class AppleMapGeocoder: MapGeocoder {

    public init() {}

    // MARK: - MapGeocoder

    public func reverseGeocoding(by location: CLLocation, addressExtractor: MapGeocoderAddressExtractor?) -> Observable<[MapGeocodingData]> {
        return Observable.create { observer -> Disposable in

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

            worker.reverseGeocodeLocation(location, completionHandler: completion)

            return Disposables.create {
                worker.cancelGeocode()
            }
        }
    }

}
