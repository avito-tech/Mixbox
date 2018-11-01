import XCTest
@testable import MixboxTestsFoundation
import Darwin

final class OutputHookLogicTests: XCTestCase {
    let hook = OutputHook.instance
    
    override func tearDown() {
        super.tearDown()
        
        try? hook.uninstallHook()
    }
    
    override func setUp() {
        try? hook.installHook()
    }
    
    func test_outputBeforeStartIsNotHandled() {
        shouldNotThrowException {
            print("not handled")
            
            try hook.resume()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.suspend()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_outputIsEmptyIfThereWereNoOutput() {
        shouldNotThrowException {
            try hook.resume()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.suspend()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_handlesWritingToStdout() {
        shouldNotThrowException {
            try hook.resume()
            
            print("foo")
            
            write(
                1,
                "bar\n".cString(using: .utf8),
                4
            )
            
            FileHandle(fileDescriptor: 1)
                .write("baz\n".data(using: .utf8) ?? Data())
            
            _ = withVaList([]) { vaArgs in
                vfprintf(
                    Darwin.stdout,
                    "qux\n".cString(using: .utf8)!.map { Int8($0) },
                    vaArgs
                )
            }
            
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.suspend()
            
            XCTAssertEqual(stdout, "foo\nbar\nbaz\nqux\n")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_handlesWritingToStderr() {
        shouldNotThrowException {
            try hook.resume()
            
            fputs("foo\n", Darwin.stderr)
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            try hook.suspend()
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "foo\n")
        }
    }
    
    func test_doesntResetAfterStop() {
        shouldNotThrowException {
            try hook.resume()
            
            print("foo")
            
            try hook.suspend()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            XCTAssertEqual(stdout, "foo\n")
            XCTAssertEqual(stderr, "")
        }
    }
    
    func test_resetsAfterStart() {
        shouldNotThrowException {
            try hook.resume()
            
            print("foo")
            
            try hook.suspend()
            try hook.resume()
            
            let stdout = hook.stdout
            let stderr = hook.stderr
            
            XCTAssertEqual(stdout, "")
            XCTAssertEqual(stderr, "")
            
            try hook.suspend()
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
