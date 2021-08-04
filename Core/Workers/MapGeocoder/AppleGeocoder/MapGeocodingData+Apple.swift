import MapKit

public extension MapGeocodingData {
    init?(placemark: CLPlacemark, addressExtractor: MapGeocoderAddressExtractor?) {
        guard let location = placemark.location else {
            return nil
        }

        coord = location.coordinate
        name = placemark.name ?? ""
        address = addressExtractor?(placemark) ?? ""
    }

    init?(mapItem: MKMapItem, addressExtractor: MapGeocoderAddressExtractor?) {
        guard let location = mapItem.placemark.location else {
            return nil
        }

        coord = location.coordinate
        name = mapItem.name ?? ""
        address = addressExtractor?(mapItem) ?? ""
    }
}
