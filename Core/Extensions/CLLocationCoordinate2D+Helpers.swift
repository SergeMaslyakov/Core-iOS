import CoreLocation

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
}
