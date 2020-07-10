import MapKit

public extension MapGeocodingData {

    init?(placemark: CLPlacemark, addressExtractor: MapGeocoderAddressExtractor?) {
        guard let location = placemark.location else {
            return nil
        }

        self.coord = location.coordinate
        self.name = placemark.name ?? ""
        self.address = addressExtractor?(placemark) ?? ""
    }

    init?(mapItem: MKMapItem, addressExtractor: MapGeocoderAddressExtractor?) {
        guard let location = mapItem.placemark.location else {
            return nil
        }

        self.coord = location.coordinate
        self.name = mapItem.name ?? ""
        self.address = addressExtractor?(mapItem) ?? ""
    }

}
