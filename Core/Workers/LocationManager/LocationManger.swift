import Foundation
import CoreLocation

import RxSwift
import RxCocoa

public protocol LocationManager: class {

    var authStatus: BehaviorRelay<CLAuthorizationStatus> { get }
    var userLocation: BehaviorRelay<CLLocation?> { get }
}
