import XCTest
import MixboxTestsFoundation

final class Collection_OnlyOrFail_Tests: TestCase {
    func test___onlyOneOrFail() {
        assertFails {
            [].onlyOneOrFail
        }
        assertFails {
            _ = [1, 2].onlyOneOrFail
        }
        
        XCTAssertEqual(
            1,
            [1].onlyOneOrFail
        )
    }
    
    func test___onlyOrFail___for_1_value() {
        assertFails {
            let _: Int = [].onlyOrFail()
        }
        assertFails {
            let _: Int = [1, 2].onlyOrFail()
        }
        
        XCTAssert((1) == [1].onlyOrFail())
    }
    
    func test___onlyOrFail___for_2_values() {
        assertFails {
            let (_, _) = [1].onlyOrFail()
        }
        assertFails {
            let (_, _) = [1, 2, 3].onlyOrFail()
        }
        
        XCTAssert((1, 2) == [1, 2].onlyOrFail())
    }
    
    func test___onlyOrFail___for_3_values() {
        assertFails {
            let (_, _, _) = [1, 2].onlyOrFail()
        }
        assertFails {
            let (_, _, _) = [1, 2, 3, 4].onlyOrFail()
        }
        
        XCTAssert((1, 2, 3) == [1, 2, 3].onlyOrFail())
    }
    
    func test___onlyOrFail___for_4_values() {
        assertFails {
            let (_, _, _, _) = [1, 2, 3].onlyOrFail()
        }
        assertFails {
            let (_, _, _, _) = [1, 2, 3, 4, 5].onlyOrFail()
        }
        
        XCTAssert((1, 2, 3, 4) == [1, 2, 3, 4].onlyOrFail())
    }
    
    func test___onlyOrFail___for_5_values() {
        assertFails {
            let (_, _, _, _, _) = [1, 2, 3, 4].onlyOrFail()
        }
        assertFails {
            let (_, _, _, _, _) = [1, 2, 3, 4, 5, 6].onlyOrFail()
        }
        
        XCTAssert((1, 2, 3, 4, 5) == [1, 2, 3, 4, 5].onlyOrFail())
    }
    
    func test___onlyOrFail___for_6_values() {
        assertFails {
            let (_, _, _, _, _, _) = [1, 2, 3, 4, 5].onlyOrFail()
        }
        assertFails {
            let (_, _, _, _, _, _) = [1, 2, 3, 4, 5, 6, 7].onlyOrFail()
        }
        
        XCTAssert((1, 2, 3, 4, 5, 6) == [1, 2, 3, 4, 5, 6].onlyOrFail())
    }
}
