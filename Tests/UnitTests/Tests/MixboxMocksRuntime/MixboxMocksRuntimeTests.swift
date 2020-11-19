import XCTest
import MixboxMocksRuntime

class MixboxMocksRuntimeTests: TestCase {
    let mock = MockFixtureProtocol()
    
    func testExample() {
        mock.stub()
            .fixtureFunction(any(), labeled: any())
            .thenInvoke { a, b in a + b }
        
        mock.stub()
            .fixtureFunction(2, labeled: any())
            .thenInvoke { _, b in b }
        
        mock.stub()
            .fixtureFunction(2, labeled: 2)
            .thenReturn(5)
        
        XCTAssertEqual(
            mock.fixtureFunction(1, labeled: 1),
            2
        )
        XCTAssertEqual(
            mock.fixtureFunction(2, labeled: 1),
            1
        )
        XCTAssertEqual(
            mock.fixtureFunction(2, labeled: 2),
            5
        )
        
        // Before expectation
        _ = mock.fixtureFunction(41, labeled: 41)
        mock.expect().fixtureFunction(41, labeled: 41)
        
        // After expectation
        mock.expect().fixtureFunction(42, labeled: 42)
        _ = mock.fixtureFunction(42, labeled: 42)
        
        mock.verify()
        
        XCTAssertEqual(
            mock.fixtureFunction(2, labeled: 2),
            5
        )
    }
}
