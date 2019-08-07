import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public final class LocationManagerImpl: NSObject, LocationManager {

    public var authStatus: Observable<CLAuthorizationStatus> {
        return authStatusRelay.asObservable()
    }

    public var userLocation: Observable<CLLocation?> {
        return userLocationRelay.asObservable()
    }

    public var defaultCoord: Observable<CLLocationCoordinate2D> {
        return defaultCoordRelay.asObservable()
    }

    public var lastKnownUserLocation: CLLocation {
        return userLocationRelay.value ?? CLLocation(latitude: defaultCoordRelay.value.latitude, longitude: defaultCoordRelay.value.longitude)
    }

    private let authStatusRelay: BehaviorRelay<CLAuthorizationStatus>
    private let userLocationRelay: BehaviorRelay<CLLocation?>
    private let defaultCoordRelay: BehaviorRelay<CLLocationCoordinate2D>

    private let locationManager = CLLocationManager()

    public init(defaultCoord: CLLocationCoordinate2D) {
        self.userLocationRelay = BehaviorRelay(value: nil)
        self.authStatusRelay = BehaviorRelay(value: CLLocationManager.authorizationStatus())
        self.defaultCoordRelay = BehaviorRelay(value: defaultCoord)

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

        authStatusRelay.accept(status)

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()

            if let location = manager.location, CLLocationCoordinate2DIsValid(location.coordinate) {
                userLocationRelay.accept(location)
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, CLLocationCoordinate2DIsValid(location.coordinate) {
            userLocationRelay.accept(location)
        }
    }

}
