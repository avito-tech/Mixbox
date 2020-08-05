import MixboxGenerators
import XCTest

final class OverflowingUInt64Tests: TestCase {
    func test___plus() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) + 1,
            0
        )
    }
    
    func test___minus() {
        XCTAssertEqual(
            OverflowingUInt64(0) - 1,
            OverflowingUInt64(UInt64.max)
        )
    }
    
    func test___multiply() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) * 2,
            OverflowingUInt64(UInt64.max - 1)
        )
    }
    
    func test___divide() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) / 2,
            OverflowingUInt64(UInt64.max / 2)
        )
    }
    
    func test___left_shift() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) << 1,
            OverflowingUInt64(UInt64.max - 1)
        )
    }
    
    func test___right_shift() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) >> 1,
            OverflowingUInt64(UInt64.max / 2)
        )
    }
    
    func test___modulo() {
        XCTAssertEqual(
            OverflowingUInt64(UInt64.max) % 2,
            OverflowingUInt64(1)
        )
    }
    
    func test___and() {
        XCTAssertEqual(
            OverflowingUInt64(0b0011) & 0b0101,
            OverflowingUInt64(0b0001)
        )
    }
    
    func test___xor() {
        XCTAssertEqual(
            OverflowingUInt64(0b0011) ^ 0b0101,
            OverflowingUInt64(0b0110)
        )
    }
    
    func test___not() {
        XCTAssertEqual(
            ~OverflowingUInt64(UInt64.max),
            OverflowingUInt64(0)
        )
    }
    
    func test___equal() {
        XCTAssertTrue(
            OverflowingUInt64(1) == OverflowingUInt64(1)
        )
        XCTAssertFalse(
            OverflowingUInt64(1) == OverflowingUInt64(2)
        )
    }
    
    func test___less() {
        XCTAssertTrue(
            OverflowingUInt64(1) < OverflowingUInt64(2)
        )
        XCTAssertFalse(
            OverflowingUInt64(1) < OverflowingUInt64(1)
        )
    }
}
