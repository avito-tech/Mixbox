public final class ReportingSystems: ReportingSystem {
    private let reportingSystems: [ReportingSystem]
    
    public init(reportingSystems: [ReportingSystem]) {
        self.reportingSystems = reportingSystems
    }
    
    // MARK: - Reporter
    
    public func reportTestCase(
        testCaseReport: TestCaseReport,
        completion: @escaping () -> ())
    {
        let dispatchGroup = DispatchGroup()
        
        for reportingSystem in reportingSystems {
            dispatchGroup.enter()
            reportingSystem.reportTestCase(testCaseReport: testCaseReport) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
