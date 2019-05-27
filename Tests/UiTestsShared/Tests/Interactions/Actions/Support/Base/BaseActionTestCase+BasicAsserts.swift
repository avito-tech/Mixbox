import XCTest
import MixboxUiTestsFoundation
import TestsIpc

extension BaseActionTestCase {
    func assertAndResetResult(
        equals expectedResult: ActionsTestsViewActionResult,
        describeFailure: (ActionsTestsViewActionResult, ActionsTestsViewActionResult) -> String)
    {
        let timeout: TimeInterval = 5
        let pollInterval: TimeInterval = 0.1
        
        spinner.spin(timeout: timeout, interval: pollInterval) { [ipcClient] in
            let actualResult = ipcClient.callOrFail(
                method: GetActionResultIpcMethod()
            )
            
            return actualResult == expectedResult
        }
        
        let actualResult = ipcClient.callOrFail(
            method: GetActionResultIpcMethod()
        )
        
        // Better to reset UI before failing
        if let error = ipcClient.callOrFail(method: ResetActionResultIpcMethod()) {
            XCTFail("Error calling ResetActionResultIpcMethod: \(error)")
        }
        
        XCTAssertEqual(expectedResult, actualResult, describeFailure(expectedResult, actualResult))
    }
}
