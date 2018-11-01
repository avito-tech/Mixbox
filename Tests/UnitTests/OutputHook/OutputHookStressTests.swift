import XCTest
@testable import MixboxTestsFoundation

// Note: OutputHook is not reliable. See its file for more comments.
final class OutputHookStressTests: XCTestCase {
    let hook = OutputHook.instance
    
    override func tearDown() {
        super.tearDown()
        
        try? hook.uninstallHook()
    }
    
    override func setUp() {
        try? hook.installHook()
    }
    
    func test_handlesLotsOfStartsAndStops() {
        shouldNotThrowException {
            for _ in 0..<1000 {
                try hook.resume()
                
                print("foo")
                
                try hook.suspend()
            }
        }
        
        for _ in 0..<100 where hook.stdout.isEmpty {
            Thread.sleep(forTimeInterval: 0.001)
        }
        
        XCTAssertEqual(hook.stdout, "foo\n")
    }
    
    // NOTE: If `installHook` is called while something is printed in background
    // then preocess can crash.
    func test_handlesLotsOfStartsAndStops_andPrintingInBackground() {
        let queue = DispatchQueue(label: "\(#function)")
        var shouldPrint = true
        
        queue.async {
            while shouldPrint {
                print("\(#function)")
            }
        }
        
        shouldNotThrowException {
            for _ in 0..<10000 {
                try hook.resume()
                try hook.suspend()
            }
            
            shouldPrint = false
        }
        
        // Expected result:
        // Should not hang or crash
        
        // To stop printing before returning from test
        queue.sync {}
    }
    
    func test_handlesLotsOfData() {
        let stringForPrint = "I will not instigate revolution"
        let actuallyPrintedString = "\(stringForPrint)\n"
        // Failed once after exceeding buffer size (so keep repetitionsCount > 3000)
        let repetitionsCount = 100000
        
        shouldNotThrowException {
            try hook.resume()
            
            for i in 0..<repetitionsCount {
                print(stringForPrint)
                
                // It seems that too much data per time interval can make everything stuck
                if i % 1000 == 0 {
                    Thread.sleep(forTimeInterval: 0.001)
                }
            }
            
            try hook.suspend()
        }
        
        let expectedStdout = Array(repeating: actuallyPrintedString, count: repetitionsCount).joined()
        XCTAssertEqual(hook.stdout, expectedStdout)
    }
    
    private func shouldNotThrowException(_ body: () throws -> ()) {
        do {
            try body()
        } catch let e {
            XCTFail("Caught expection (not expected to catch any): \(e)")
        }
    }
}
