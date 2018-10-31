import XCTest
import MixboxTestsFoundation
import Darwin

// Note: OutputHook is not reliable. See its file for more comments.
final class OutputHookTests: XCTestCase {
    let hook = OutputHook()
    
    func test_outputBeforeStartIsNotHandled() {
        shouldNotThrowException {
            print("not handled")
            
            try hook.start()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.stop()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_outputIsEmptyIfThereWereNoOutput() {
        shouldNotThrowException {
            try hook.start()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.stop()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_handlesWritingToStdout() {
        shouldNotThrowException {
            try hook.start()
            
            print("foo")
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.stop()
            
            XCTAssertEqual(stdout, "foo\n")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_handlesWritingToStderr() {
        shouldNotThrowException {
            try hook.start()
            
            fputs("foo\n", Darwin.stderr)
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.stop()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "foo\n")
        }
    }
    
    func test_doesntResetAfterStop() {
        shouldNotThrowException {
            try hook.start()
            
            print("foo")

            sleep(1)
            
            try hook.stop()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            XCTAssertEqual(stdout, "foo\n")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_resetsAfterStart() {
        shouldNotThrowException {
            try hook.start()
            
            print("foo")
            
            try hook.stop()
            try hook.start()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
        }
    }
    
    private func shouldNotThrowException(_ body: () throws -> ()) {
        do {
            try body()
        } catch let e {
            XCTFail("Caught expection (not expected to catch any): \(e)")
        }
    }
}
