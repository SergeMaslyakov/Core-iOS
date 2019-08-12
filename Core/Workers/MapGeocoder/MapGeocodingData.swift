import Foundation
import CoreLocation

public struct MapGeocodingData {

    public let coord: CLLocationCoordinate2D
    public let address: String

    public init(coord: CLLocationCoordinate2D, address: String) {
        self.coord = coord
        self.address = address
    }

}
