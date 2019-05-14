import XCTest
import MixboxTestsFoundation

class AutomaticCurrentTestCaseProviderTests: XCTestCase {
    func test() {
        
        XCTAssert(
            AutomaticCurrentTestCaseProvider().currentTestCase() === self
        )
    }
}
