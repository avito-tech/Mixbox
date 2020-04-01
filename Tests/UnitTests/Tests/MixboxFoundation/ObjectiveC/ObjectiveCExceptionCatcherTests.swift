import XCTest
import MixboxFoundation

class ObjectiveCExceptionCatcherTests: XCTestCase {
    let exceptionToRaise = NSException(name: NSExceptionName(rawValue: "1"), reason: "2", userInfo: ["3": "4"])
    
    func test___catch___catches_exception___if_exception_is_raised() {
        var caughtException: NSException?
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                exceptionToRaise.raise()
            },
            catch: { exception in
                caughtException = exception
            }
        )
        
        XCTAssertEqual(caughtException?.name, exceptionToRaise.name)
        XCTAssertEqual(caughtException?.reason, exceptionToRaise.reason)
        XCTAssertEqual(caughtException?.userInfo as? [String: String], exceptionToRaise.userInfo as? [String: String])
    }
    
    func test___catch___calls_finally___if_exception_is_raised() {
        var finallyWasCalled = false
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                exceptionToRaise.raise()
            },
            catch: { _ in },
            finally: {
                finallyWasCalled = true
            }
        )
        
        XCTAssert(finallyWasCalled)
    }
    
    func test___catch___doesnt_catch_exception___if_there_is_no_exception() {
        var caughtException: NSException?
        
        ObjectiveCExceptionCatcher.catch(
            try: {
               // nothing
            },
            catch: { exception in
                caughtException = exception
            }
        )
        
        XCTAssertNil(caughtException)
    }
    
    func test___catch___calls_finally___if_there_is_no_exception() {
        var finallyWasCalled = false
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                // nothing
            },
            catch: { _ in },
            finally: {
                finallyWasCalled = true
            }
        )
        
        XCTAssert(finallyWasCalled)
    }
    
    func test___catch___calls_finally___exception_is_rethrown() {
        var finallyWasCalled = false
        
        ObjectiveCExceptionCatcher.catch(
            try: {
                // nothing
            },
            catch: { exception in
                exception.raise()
            },
            finally: {
                finallyWasCalled = true
            }
        )
        
        XCTAssert(finallyWasCalled)
    }
}
