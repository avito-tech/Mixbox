public final class TestCaseReport {
    // Identification
    public let uuid: NSUUID
    
    // Other info
    public let testCaseClassName: String?
    
    // Contents
    public let testMethods: [TestMethodReport]
    
    // Status
    public let status: TestReportStatus
    public let startDate: Date
    public let stopDate: Date
    
    public init(
        uuid: NSUUID,
        testCaseClassName: String?,
        testMethods: [TestMethodReport],
        status: TestReportStatus,
        startDate: Date,
        stopDate: Date)
    {
        self.uuid = uuid
        self.testCaseClassName = testCaseClassName
        self.testMethods = testMethods
        self.status = status
        self.startDate = startDate
        self.stopDate = stopDate
    }
}
