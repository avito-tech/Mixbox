import XCTest
import MixboxTestsFoundation

final class Collection_ElementOrFail_Tests: TestCase {
    func test() {
        assertFails {
            [].elementOrFail(index: -1)
        }
        assertFails {
            [].elementOrFail(index: 0)
        }
        assertFails {
            [].elementOrFail(index: 1)
        }
        
        assertFails {
            _ = [0].elementOrFail(index: -1)
        }
        XCTAssertEqual(
            0,
            [0].elementOrFail(index: 0)
        )
        assertFails {
            _ = [0].elementOrFail(index: 1)
        }
        
        assertFails {
            _ = [0, 1].elementOrFail(index: -1)
        }
        XCTAssertEqual(
            0,
            [0, 1].elementOrFail(index: 0)
        )
        XCTAssertEqual(
            1,
            [0, 1].elementOrFail(index: 1)
        )
    }
}
