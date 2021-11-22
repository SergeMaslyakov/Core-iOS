import CoreLocation
import Foundation

import RxCocoa
import RxSwift

public protocol LocationManager: AnyObject {
    var authStatus: Observable<CLAuthorizationStatus> { get }

    func requestAccessToLocation(_ desiredLevel: CLAuthorizationStatus)
    func lastKnownAuthStatus() -> CLAuthorizationStatus

    var firstUserLocationAcquired: Observable<Void> { get }

    var userLocation: Observable<CLLocation?> { get }
    var userHeading: Observable<CLHeading?> { get }

    var lastKnownUserLocation: CLLocation? { get }
    var lastKnownUserHeading: CLHeading { get }
}
