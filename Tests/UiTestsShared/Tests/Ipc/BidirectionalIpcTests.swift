// There are client+server pairs in all applications (tests & apps that support Mixbox).
// So requests can be initiated in all directions (app->tests & tests->app).

import TestsIpc
import XCTest

// TODO: Fix for BlackBox tests
final class BidirectionalIpcTests: TestCase {
    func test() {
        ensureIpcIsInitiated()
        
        do {
            let result = try ipcClient.callOrThrow(
                method: BidirectionalIpcPingPongMethod(),
                arguments: BidirectionalIpcPingPongMethod.Arguments(
                    countOfCallsLeft: 5
                )
            )
            
            let returnValue = try result.getReturnValue()
            
            XCTAssertEqual(
                returnValue,
                [0, 1, 2, 3, 4, 5]
            )
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
