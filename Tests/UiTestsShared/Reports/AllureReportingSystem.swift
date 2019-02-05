import MixboxAllure

public final class AllureReportingSystem: ReportingSystem {
    private let allureResultsStorage: AllureResultsStorage
    
    public init(allureResultsStorage: AllureResultsStorage) {
        self.allureResultsStorage = allureResultsStorage
    }
    
    public func reportTestCase(
        testCaseReport: TestCaseReport,
        completion: @escaping () -> ())
    {
        let container = AllureContainer(
            uuid: AllureUuid(uuid: testCaseReport.uuid),
            name: testCaseReport.testCaseClassName,
            children: testCaseReport.testMethods.map { AllureUuid(uuid: $0.uuid) },
            description: nil,
            descriptionHtml: nil,
            afters: [],
            befores: [],
            links: [],
            start: AllureTimestamp(date: testCaseReport.startDate),
            stop: AllureTimestamp(date: testCaseReport.stopDate)
        )
        
        allureResultsStorage.store(allureContainer: container)
        
        for testMethodReport in testCaseReport.testMethods {
            reportTestMethod(testMethodReport: testMethodReport)
        }
        
        completion()
    }
    
    private func reportTestMethod(testMethodReport: TestMethodReport) {
        let allureResult = AllureResult(
            uuid: AllureUuid(uuid: testMethodReport.uuid),
            fullName: testMethodReport.uniqueName,
            historyId: nil, // TODO: Proper value
            labels: labels(testMethodReport: testMethodReport),
            links: [],
            name: testMethodReport.nameForDisplay,
            status: status(testReportStatus: testMethodReport.status),
            statusDetails: AllureStatusDetails(
                known: nil,
                muted: nil,
                flaky: testMethodReport.isFlaky,
                message: nil,
                trace: nil
            ),
            stage: .finished,
            description: nil,
            descriptionHtml: nil,
            steps: testMethodReport.steps.map(step),
            start: AllureTimestamp(date: testMethodReport.startDate),
            stop: AllureTimestamp(date: testMethodReport.stopDate),
            attachments: [],
            parameters: []
        )
        
        allureResultsStorage.store(allureResult: allureResult)
    }
    
    private func step(testStepReport: TestStepReport)
        -> AllureStepResult
    {
        return AllureStepResult(
            name: testStepReport.name,
            status: status(testReportStatus: testStepReport.status),
            statusDetails: nil,
            stage: .finished,
            description: testStepReport.description,
            descriptionHtml: nil,
            steps: testStepReport.steps.map(step),
            start: AllureTimestamp(date: testStepReport.startDate),
            stop: AllureTimestamp(date: testStepReport.stopDate),
            attachments: testStepReport.attachments.compactMap(attachment),
            parameters: []
        )
    }
    
    private func status(testReportStatus: TestReportStatus) -> AllureStatus {
        switch testReportStatus {
        case .passed:
            return .passed
        case .failed:
            return .failed
        case .manual:
            return .failed
        case .error:
            return .failed
        }
    }
    
    private func attachment(testReportAttachment: TestReportAttachment) -> AllureAttachment? {
        return allureResultsStorage.store(artifact: testReportAttachment.artifact)
    }
    
    private func labels(
        testMethodReport: TestMethodReport)
        -> [AllureLabel]
    {
        var labels = [AllureLabel]()
        
        if let className = testMethodReport.testCaseClassName {
            labels.append(
                AllureLabel(
                    name: .testClass,
                    value: className
                )
            )
        }
        
        if let methodName = testMethodReport.testMethodNameForDisplay {
            labels.append(
                AllureLabel(
                    name: .testMethod,
                    value: methodName
                )
            )
        }
        
        if let suiteName = testMethodReport.testCaseClassName {
            labels.append(
                AllureLabel(
                    name: .suite,
                    value: suiteName
                )
            )
        }
        
        if let subSuiteName = testMethodReport.testCaseClassName {
            labels.append(
                AllureLabel(
                    name: .subSuite,
                    value: subSuiteName
                )
            )
        }
        
        return labels
    }
}
