import MapKit

public enum MKMapUtils {

    public struct Box {
        public let center: CLLocationCoordinate2D
        public let span: MKCoordinateSpan

        public let sw: CLLocationCoordinate2D
        public let ne: CLLocationCoordinate2D
    }

    public static func makeCoordinateRegion(from coordinates: [CLLocationCoordinate2D]) -> Box? {
        guard let initial = coordinates.first else { return nil }

        var sw: CLLocationCoordinate2D = initial
        var ne: CLLocationCoordinate2D = initial

        coordinates.forEach {
            if $0.latitude > ne.latitude {
                ne.latitude = $0.latitude
            }

            if $0.longitude > ne.longitude {
                ne.longitude = $0.longitude
            }

            if sw.latitude > $0.latitude {
                sw.latitude = $0.latitude
            }

            if sw.longitude > $0.longitude {
                sw.longitude = $0.longitude
            }
        }

        let latitudeDelta = abs((ne.latitude - sw.latitude) / 2)
        let longitudeDelta = abs((ne.longitude - sw.longitude) / 2)
        let center = CLLocationCoordinate2D(latitude: ne.latitude - latitudeDelta, longitude: ne.longitude - longitudeDelta)

        let span: MKCoordinateSpan

        if coordinates.count == 1 {
            let region = MKCoordinateRegion(center: coordinates[0],
                                            latitudinalMeters: 600,
                                            longitudinalMeters: 600)
            span = region.span
        } else {
            span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        }

        return Box(center: center, span: span, sw: sw, ne: ne)
    }

    public static func addInsetsInMeters(span: MKCoordinateSpan, inset: Double) -> MKCoordinateSpan {
        // one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        // one degree of longitude spans a distance of approximately 111 kilometers (69 miles) at the equator but shrinks to 0 kilometers at the poles.
        return MKCoordinateSpan(latitudeDelta: span.latitudeDelta + inset/111000, longitudeDelta: span.longitudeDelta + inset/111000)
    }
}
