import XCTest
import MixboxFoundation

class ObjectiveCExceptionCatcherTests: XCTestCase {
    func test_catchingException() {
        let raisedException = NSException(name: NSExceptionName(rawValue: "1"), reason: "2", userInfo: ["3": "4"])
        var catchedException: NSException?
        var finallyIsCalled = false
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                raisedException.raise()
            },
            catch: { exception in
                catchedException = exception
            },
            finally: {
                finallyIsCalled = true
            }
        )
        
        XCTAssertTrue(finallyIsCalled)
        XCTAssertEqual(catchedException?.name, raisedException.name)
        XCTAssertEqual(catchedException?.reason, raisedException.reason)
        XCTAssertEqual(catchedException?.userInfo as? [String: String], raisedException.userInfo as? [String: String])
    }
    
    func test_noException() {
        var catchedException: NSException?
        var finallyIsCalled = false
        
        ObjectiveCExceptionCatcher.catch(
            try: {
               // nothing
            },
            catch: { exception in
                catchedException = exception
            },
            finally: {
                finallyIsCalled = true
            }
        )
        
        XCTAssertTrue(finallyIsCalled)
        XCTAssertNil(catchedException)
    }
}
