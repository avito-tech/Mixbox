import Foundation

public final class TestMethodReport {
    public let uuid: NSUUID
    
    public let uniqueName: String? // "-[MyTestCase test:]"
    public let testMethodName: String? // "test"
    public let testCaseClassName: String? // "MyTestCase"
    
    public let status: TestReportStatus
    public let isFlaky: Bool? // точно да, точно нет, неизвестно
    public let startDate: Date
    public let stopDate: Date
    
    public let steps: [TestStepReport]
    public let failures: [TestReportFailure]

    public var nameForDisplay: String? {
        return testMethodNameForDisplay
    }
    
    public var testMethodNameForDisplay: String? {
        return testMethodName ?? uniqueName
    }
    
    public var testSuiteNameForDisplay: String? {
        return testCaseClassName
    }
    
    public var testSubsuiteNameForDisplay: String? {
        return testCaseClassName
    }

// sourcery:inline:auto:TestMethodReport.Init
    public init(
        uuid: NSUUID,
        uniqueName: String?,
        testMethodName: String?,
        testCaseClassName: String?,
        status: TestReportStatus,
        isFlaky: Bool?,
        startDate: Date,
        stopDate: Date,
        steps: [TestStepReport],
        failures: [TestReportFailure])
    {
        self.uuid = uuid
        self.uniqueName = uniqueName
        self.testMethodName = testMethodName
        self.testCaseClassName = testCaseClassName
        self.status = status
        self.isFlaky = isFlaky
        self.startDate = startDate
        self.stopDate = stopDate
        self.steps = steps
        self.failures = failures
    }
// sourcery:end
}
