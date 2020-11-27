import MixboxUiTestsFoundation
import XCTest

final class FailuresAreHighlightedInCorrectPlacesInIdeTests: TestCase {
    // Current implementation can not symbolicate error if code doesn't exists (or wasn't built) on current machine.
    // TODO: Do not skip this check on CI.
    
    func disabled_test_whenCallingFromTest() {
        assertFails(description: "failed - message", expected: true) { fails in
            XCTFail("message", file: "fallback", line: 1); fails.here()
        }
    }
    
    // TODO: XCTFail doesn't work from background, but we can test our TestFailureRecorder
    func disabled_test_whenCallingFromBackground() {
        assertFails(description: "failed - message") { fails in
            let background = DispatchQueue(label: "background")
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            background.async {
                XCTAssert(Thread.current != Thread.main, "Test is not configured properly")
                XCTFail("message", file: "fallback", line: 1); fails.here()
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
        }
    }
    
    func disabled_test_parameterized_test() {
        assertFails(description: "failed - message", expected: true) { fails in
            XCTFail("message", file: "fallback", line: 1); fails.here()
        }
        
        parameterized_test(message: "message")
        parameterized_test(message: "other message")
    }
    
    func parameterized_test(message: String) {
        assertFails(description: "failed - \(message)", expected: true) { fails in
            XCTFail(message, file: "fallback", line: 1); fails.here()
        }
        
        assertFails(description: "failed - message", expected: true) { fails in
            functionWithNameOtherThanTestOrParameterizedTest(); fails.here()
        }
    }
    
    func functionWithNameOtherThanTestOrParameterizedTest() {
        // The following line will not be highlighted, because hightlighting is configured to
        // highlight only "test" and "parameterized_test" functions
        XCTFail("message", file: "fallback", line: 1)
    }
}
