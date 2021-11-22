import CoreLocation

public struct MapGeoBox: Equatable {
    public init(ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
        self.ne = ne
        self.sw = sw
    }

    public init(center: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees) {
        self.ne = CLLocationCoordinate2D(latitude: center.latitude + latitudeDelta, longitude: center.longitude + longitudeDelta)
        self.sw = CLLocationCoordinate2D(latitude: center.latitude - latitudeDelta, longitude: center.longitude - longitudeDelta)
    }

    public let ne: CLLocationCoordinate2D
    public let sw: CLLocationCoordinate2D

    public var center: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: sw.latitude + latitudeDelta, longitude: sw.longitude + longitudeDelta)
    }

    public var longitudeDelta: CLLocationDegrees {
        (ne.longitude - sw.longitude) / 2
    }

    public var latitudeDelta: CLLocationDegrees {
        (ne.latitude - sw.latitude) / 2
    }

    // MARK: - Equatable

    public static func == (lhs: MapGeoBox, rhs: MapGeoBox) -> Bool {
        lhs.ne == rhs.ne && lhs.sw == rhs.sw
    }
}
