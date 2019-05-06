import XCTest
import MixboxUiTestsFoundation
import TestsIpc

extension BaseActionTestCase {
    func assertAndResetResult(equals expectedResult: ActionsTestsViewActionResult, describeFailure: (ActionsTestsViewActionResult, ActionsTestsViewActionResult) -> String) {
        let timeout: TimeInterval = 5
        let pollInterval: TimeInterval = 0.1
        let maxIterations = Int(timeout / pollInterval)
        let lastIteration = maxIterations - 1
        
        for iteration in 0..<maxIterations {
            let actualResult = ipcClient.callOrFail(
                method: GetActionResultIpcMethod()
            )
            
            if actualResult == expectedResult || iteration == lastIteration {
                // Better to reset UI before failing
                if let error = ipcClient.callOrFail(method: ResetActionResultIpcMethod()) {
                    XCTFail("Error calling ResetActionResultIpcMethod: \(error)")
                }
                
                XCTAssertEqual(expectedResult, actualResult, describeFailure(expectedResult, actualResult))
                break
            }
            
            Thread.sleep(forTimeInterval: pollInterval)
        }
    }
}
