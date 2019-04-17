import MixboxFoundation
import XCTest

final class OnceTokenTests: XCTestCase {
    func test_ThreadUnsafeOnceToken() {
        check(onceToken: ThreadUnsafeOnceToken())
    }
    
    func test_ThreadSafeOnceToken() {
        check(onceToken: ThreadSafeOnceToken())
    }
    
    func check(onceToken: OnceToken) {
        var x = 1
        
        onceToken.executeOnce { x += 1 }
        
        XCTAssertEqual(x, 2)
        
        onceToken.executeOnce { x += 1 }
        
        XCTAssertEqual(x, 2)
    }
}
