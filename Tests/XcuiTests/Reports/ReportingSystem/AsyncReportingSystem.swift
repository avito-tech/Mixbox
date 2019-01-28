import XCTest

public final class AsyncReportingSystem: ReportingSystem {
    private let reportingSystem: ReportingSystem
    private let dispatchGroup = DispatchGroup()
    private let queue = DispatchQueue(
        label: "AsyncReportingSystem.queue",
        attributes: .concurrent
    )
    
    public init(reportingSystem: ReportingSystem) {
        self.reportingSystem = reportingSystem
    }
    
    public func reportTestCase(
        testCaseReport: TestCaseReport,
        completion: @escaping () -> ())
    {
        dispatchGroup.enter()
        
        let overridenCompletion = { [dispatchGroup] in
            completion()
            dispatchGroup.leave()
        }
        
        queue.async { [weak self] in
            guard let strongSelf = self else {
                overridenCompletion()
                return
            }
            
            strongSelf.reportingSystem.reportTestCase(testCaseReport: testCaseReport) {
                overridenCompletion()
            }
        }
    }
    
    public func waitForLastReportBeingSent(timeout: TimeInterval) {
        let expectation = XCTestExpectation(description: "last report was sent")
        
        // Выглядит немного дико. XCTWaiter прокручивает ранлуп, поэтому мы можем затормозить
        // этот метод до наступления expectation синхронно прямо в мейнтреде.
        
        dispatchGroup.notify(queue: .main) {
            expectation.fulfill()
        }
        
        _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
    }
}
