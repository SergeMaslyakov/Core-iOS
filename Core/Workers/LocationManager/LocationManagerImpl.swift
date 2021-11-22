import CoreLocation
import Foundation

import RxCocoa
import RxSwift

public final class LocationManagerImpl: NSObject, LocationManager {
    public var authStatus: Observable<CLAuthorizationStatus> {
        authStatusRelay.asObservable().share()
    }

    public var userLocation: Observable<CLLocation?> {
        userLocationRelay.asObservable().share()
    }

    public var userHeading: Observable<CLHeading?> {
        userHeadingRelay.asObservable().share()
    }

    public var lastKnownUserLocation: CLLocation? {
        userLocationRelay.value
    }

    public var lastKnownUserHeading: CLHeading {
        userHeadingRelay.value ?? CLHeading()
    }

    public var firstUserLocationAcquired: Observable<Void> {
        firstUserLocationAcquiredSubject.asObservable()
    }

    public func requestAccessToLocation(_ desiredLevel: CLAuthorizationStatus) {
        switch desiredLevel {
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    public func lastKnownAuthStatus() -> CLAuthorizationStatus {
        authStatusRelay.value
    }

    private let firstUserLocationAcquiredSubject = PublishSubject<Void>()
    private let authStatusRelay: BehaviorRelay<CLAuthorizationStatus>
    private let userLocationRelay: BehaviorRelay<CLLocation?>
    private let userHeadingRelay: BehaviorRelay<CLHeading?>

    private let locationManager = CLLocationManager()

    public init(askAuthorizationStatus: Bool = false) {
        self.userLocationRelay = BehaviorRelay(value: nil)
        self.userHeadingRelay = BehaviorRelay(value: nil)
        self.authStatusRelay = BehaviorRelay(value: CLLocationManager.authorizationStatus())

        super.init()

        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            if askAuthorizationStatus {
                locationManager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        default:
            break
        }
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        authStatusRelay.accept(status)

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()

            if let location = manager.location, CLLocationCoordinate2DIsValid(location.coordinate) {
                userLocationRelay.accept(location)
                firstUserLocationAcquiredSubject.onNext(())
            }
        } else {
            userLocationRelay.accept(nil)
            userHeadingRelay.accept(nil)

            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, CLLocationCoordinate2DIsValid(location.coordinate) {
            let isEmpty = userLocationRelay.value == nil
            userLocationRelay.accept(location)

            if isEmpty {
                firstUserLocationAcquiredSubject.onNext(())
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeadingRelay.accept(newHeading)
    }

    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        true
    }
}
