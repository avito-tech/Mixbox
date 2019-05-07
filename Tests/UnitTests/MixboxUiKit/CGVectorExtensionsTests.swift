import XCTest

final class CGVectorExtensionsTests: TestCase {
    func test_mb_angle() {
        XCTAssertEqual(
            CGVector(dx: 1, dy: 0).mb_angle(),
            0
        )
        
        XCTAssertEqual(
            CGVector(dx: 1, dy: 1).mb_angle(),
            .pi / 4
        )
        
        XCTAssertEqual(
            CGVector(dx: 0, dy: 1).mb_angle(),
            .pi / 2
        )
        
        XCTAssertEqual(
            CGVector(dx: -1, dy: 0).mb_angle(),
            .pi
        )
        
        XCTAssertEqual(
            CGVector(dx: 0, dy: -1).mb_angle(),
            -.pi / 2
        )
        
        XCTAssertEqual(
            CGVector(dx: 1, dy: 2).mb_angle(),
            1.1071487177940904
        )
        
        XCTAssertEqual(
            CGVector(dx: 2, dy: 1).mb_angle(),
            0.4636476090008061
        )
    }
}
