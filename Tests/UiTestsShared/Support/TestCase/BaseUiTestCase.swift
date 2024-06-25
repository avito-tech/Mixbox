import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxIpcCommon
import TestsIpc

class BaseUiTestCase: BaseTestCase {    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - Making assertion failures test failures
    
    // Note: Emcee can not track error in tearDown yet, so we use invokeTest instead.
    override func invokeTest() {
        super.invokeTest()
        
        let result = synchronousIpcClient.call(
            method: GetRecordedAssertionFailuresIpcMethod(),
            arguments: GetRecordedAssertionFailuresIpcMethod.Arguments(
                sinceIndex: nil
            )
        )
        
        switch result {
        case .data(let data):
            for failure in data {
                testFailureRecorder.recordFailure(
                    description: failure.message,
                    shouldContinueTest: true
                )
            }
        case .error:
            // If app is not launched, it can be error.
            // It is okay to do nothing.
            break
        }
    }
}
