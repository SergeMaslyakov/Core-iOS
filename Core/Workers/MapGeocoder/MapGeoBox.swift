import CoreLocation

public struct MapGeoBox {

    public init(ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
        self.ne = ne
        self.sw = sw
    }

    public let ne: CLLocationCoordinate2D
    public let sw: CLLocationCoordinate2D

    var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: sw.latitude + latitudeDelta, longitude: sw.longitude + longitudeDelta)
    }

    var longitudeDelta: CLLocationDegrees {
        return (ne.longitude - sw.longitude) / 2
    }

    var latitudeDelta: CLLocationDegrees {
        return (ne.latitude - sw.latitude) / 2
    }
}
