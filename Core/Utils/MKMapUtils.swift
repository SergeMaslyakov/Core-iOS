import MapKit

public enum MKMapUtils {

    public static func makeCoordinateRegion(from coordinates: [CLLocationCoordinate2D]) -> MapGeoBox? {
        guard coordinates.count > 1 else { return calculateCoordinateRegion(from: coordinates) }

        let polygon: MKPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        let mapRect = polygon.boundingMapRect.insetBy(dx: 100, dy: 100)

        let region = MKCoordinateRegion(mapRect)

        return MapGeoBox(ne: CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta,
                                                    longitude: region.center.longitude + region.span.longitudeDelta),
                         sw: CLLocationCoordinate2D(latitude: region.center.latitude - region.span.latitudeDelta,
                                                    longitude: region.center.longitude - region.span.longitudeDelta))
    }

    private static func calculateCoordinateRegion(from coordinates: [CLLocationCoordinate2D]) -> MapGeoBox? {
        guard let initial = coordinates.first, coordinates.count > 1 else { return nil }

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

        return MapGeoBox(ne: ne, sw: sw)
    }

    public static func addInsetsInMeters(span: MKCoordinateSpan, inset: Double) -> MKCoordinateSpan {
        // one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        // one degree of longitude spans a distance of approximately 111 kilometers (69 miles) at the equator but shrinks to 0 kilometers at the poles.
        return MKCoordinateSpan(latitudeDelta: span.latitudeDelta + inset/111000, longitudeDelta: span.longitudeDelta + inset/111000)
    }
}
