import CoreLocation

public struct MapGeoBox {

    public init(ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
        self.ne = ne
        self.sw = sw
    }

    public let ne: CLLocationCoordinate2D
    public let sw: CLLocationCoordinate2D

    public var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: sw.latitude + latitudeDelta, longitude: sw.longitude + longitudeDelta)
    }

    public var longitudeDelta: CLLocationDegrees {
        return (ne.longitude - sw.longitude) / 2
    }

    public var latitudeDelta: CLLocationDegrees {
        return (ne.latitude - sw.latitude) / 2
    }

}
