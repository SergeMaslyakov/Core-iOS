import CoreLocation
import Foundation

public struct MapGeocodingData {
    public let coord: CLLocationCoordinate2D
    public let name: String
    public let address: String

    public init(coord: CLLocationCoordinate2D, name: String, address: String) {
        self.coord = coord
        self.name = name
        self.address = address
    }

    public init(coord: CLLocationCoordinate2D) {
        self.coord = coord

        let coordStr = coord.toString()
        name = coordStr
        address = coordStr
    }
}
