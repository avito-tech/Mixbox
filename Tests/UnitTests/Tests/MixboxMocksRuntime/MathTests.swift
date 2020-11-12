import XCTest
import MixboxMocksRuntime

class MathTests: XCTestCase {
    func testExample() {
        let mathMock = MathMock()
        
        mathMock
            .stub()
            .sum(any(), b: any())
            .thenInvoke { a, b in a + b }
        
        mathMock
            .stub()
            .sum(2, b: any())
            .thenInvoke { _, b in b }
        
        mathMock
            .stub()
            .sum(2, b: 2)
            .thenReturn(5)
        
        XCTAssertEqual(
            mathMock.sum(1, b: 1),
            2
        )
        XCTAssertEqual(
            mathMock.sum(2, b: 1),
            1
        )
        XCTAssertEqual(
            mathMock.sum(2, b: 2),
            5
        )
        
        // Before expectation
        _ = mathMock.sum(41, b: 41)
        mathMock.expect().sum(41, b: 41)
        
        // After expectation
        mathMock.expect().sum(42, b: 42)
        _ = mathMock.sum(42, b: 42)
        
        mathMock.verify()
        
        XCTAssertEqual(
            mathMock.sum(2, b: 2),
            5
        )
    }
}
