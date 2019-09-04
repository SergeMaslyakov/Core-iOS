import CoreLocation

extension CLLocationCoordinate2D: Comparable {}

public extension CLLocationCoordinate2D {

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func toString(verbose: Bool = false) -> String {
        if verbose {
            return String(format: "lat: %.5f, lon: %.5f", latitude, longitude)
        }

        return String(format: "%.5f, %.5f", latitude, longitude)
    }

    // MARK: - Comparable

    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    static func < (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude < rhs.latitude && lhs.longitude < rhs.longitude
    }

    static func > (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude > rhs.latitude &&  lhs.longitude > rhs.longitude
    }
}
