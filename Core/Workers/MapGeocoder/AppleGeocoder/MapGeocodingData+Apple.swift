import Foundation
import CoreLocation

public extension MapGeocodingData {

    init?(placemark: CLPlacemark, addressExtractor: MapGeocoderAddressExtractor?) {
        guard let location = placemark.location else {
            return nil
        }

        self.coord = location.coordinate
        self.address = addressExtractor?(placemark) ?? ""
    }

}
