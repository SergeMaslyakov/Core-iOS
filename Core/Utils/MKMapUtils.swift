import MapKit

public enum MKMapUtils {

    public static func makeCoordinateRegion(from coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion? {
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
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)

        return MKCoordinateRegion(center: center, span: span)
    }
}
