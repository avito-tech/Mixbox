import XCTest

public final class AutomaticCurrentTestCaseProvider: CurrentTestCaseProvider {
    public init() {
    }
    
    public func currentTestCase() -> XCTestCase? {
        #if compiler(>=5.3)
        // Xcode 12+
        //
        // In Xcode 12 `_XCTCurrentTestCase` is now returning nil always:
        // ```
        // int __XCTCurrentTestCase() {
        //     return 0x0;
        // }
        // ```
        //
        // Ironically, we can use XCTestMisuseObserver to get current testcase.
        //
        let misuseObserver = XCTestObservationCenter
            .shared
            .observers
            .compactMap { $0 as? XCTestMisuseObserver }
            .first
        return misuseObserver?.currentTestCase
        #else
        return _XCTCurrentTestCase() as? XCTestCase
        #endif
    }
}
