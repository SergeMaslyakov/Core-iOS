import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public final class LocationManagerImpl: NSObject, LocationManager {

    public let authStatus: BehaviorRelay<CLAuthorizationStatus>
    public let userLocation: BehaviorRelay<CLLocation?>

    private let locationManager = CLLocationManager()

    public override init() {
        self.userLocation = BehaviorRelay(value: nil)
        self.authStatus = BehaviorRelay(value: CLLocationManager.authorizationStatus())

        super.init()

        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }

    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        authStatus.accept(status)

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()

            if let location = manager.location, CLLocationCoordinate2DIsValid(location.coordinate) {
                userLocation.accept(location)
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, CLLocationCoordinate2DIsValid(location.coordinate) {
            userLocation.accept(location)
        }
    }

}
