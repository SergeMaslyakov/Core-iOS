import CoreLocation

public extension CLLocationCoordinate2D {

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

}
