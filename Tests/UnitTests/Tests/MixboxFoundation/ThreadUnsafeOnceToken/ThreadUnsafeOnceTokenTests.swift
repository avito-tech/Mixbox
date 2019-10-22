import MixboxFoundation
import XCTest

final class OnceTokenTests: XCTestCase {
    func test_ThreadUnsafeOnceToken() {
        check(onceToken: ThreadUnsafeOnceToken<Int>())
    }
    
    func test_ThreadSafeOnceToken() {
        check(onceToken: ThreadSafeOnceToken<Int>())
    }
    
    func check<T: OnceToken>(onceToken: T) where T.ReturnValue == Int {
        let x = onceToken.executeOnce {
            1
        }
        
        XCTAssertEqual(x, 1)
        
        let y = onceToken.executeOnce {
            2
        }
        
        XCTAssertEqual(y, 1)
    }
}
