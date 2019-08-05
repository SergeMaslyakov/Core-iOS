import XCTest
import MapKit

@testable import Core

class MKMapUtilsTests: XCTestCase {

    private var singleCoord: CLLocationCoordinate2D!
    private var coords: [CLLocationCoordinate2D]!
    private var span: MKCoordinateSpan!

    override func setUp() {
        super.setUp()

        singleCoord = CLLocationCoordinate2D(latitude: 40.759211, longitude: -73.984638)
        coords = [
            CLLocationCoordinate2D(latitude: 40.73777, longitude: -73.987833),
            CLLocationCoordinate2D(latitude: 40.735892, longitude: -73.987114),
            CLLocationCoordinate2D(latitude: 40.735868, longitude: -73.987036),
            CLLocationCoordinate2D(latitude: 40.738524, longitude: -73.985737),
            CLLocationCoordinate2D(latitude: 40.737643, longitude: -73.987627)
        ]

        span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    }

    override func tearDown() {
        singleCoord = nil
        coords = nil
        span = nil

        super.tearDown()
    }

    func testMakingRegionFromSingleCoord() {

        let box = MKMapUtils.makeCoordinateRegion(from: [singleCoord])!

        XCTAssertTrue(box.center.latitude == 40.759211)
        XCTAssertTrue(box.center.longitude == -73.984638)
    }

    func testMakingRegionFromCoords() {

        let box = MKMapUtils.makeCoordinateRegion(from: coords)!

        XCTAssertTrue(box.ne.latitude == 40.738524)
        XCTAssertTrue(box.ne.longitude == -73.985737)

        XCTAssertTrue(box.sw.latitude == 40.735868)
        XCTAssertTrue(box.sw.longitude == -73.987833)
    }

    func testAddingInsetForSpan() {

        let spanWithInset = MKMapUtils.addInsetsInMeters(span: span, inset: 1000)

        XCTAssertTrue(spanWithInset.latitudeDelta > span.latitudeDelta)
        XCTAssertTrue(spanWithInset.longitudeDelta > span.longitudeDelta)
    }
}
