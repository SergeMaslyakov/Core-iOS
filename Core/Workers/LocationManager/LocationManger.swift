import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public protocol LocationManager: class {

    var authStatus: Observable<CLAuthorizationStatus> { get }
    var userLocation: Observable<CLLocation?> { get }
    var userHeading: Observable<CLHeading?> { get }
    var defaultCoord: Observable<CLLocationCoordinate2D> { get }

    var lastKnownUserLocation: CLLocation { get }
    var lastKnownUserHeading: CLHeading { get }
}
