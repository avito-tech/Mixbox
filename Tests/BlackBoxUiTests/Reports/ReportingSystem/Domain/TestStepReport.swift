import MixboxReporting

public final class TestStepReport {
    public let uuid: NSUUID
    public let name: String
    public let description: String?
    public let type: StepType
    public let status: TestReportStatus
    public let steps: [TestStepReport]
    public let startDate: Date
    public let stopDate: Date
    public let attachments: [TestReportAttachment]
    
    public init(
        uuid: NSUUID,
        name: String,
        description: String?,
        type: StepType,
        status: TestReportStatus,
        steps: [TestStepReport],
        startDate: Date,
        stopDate: Date,
        attachments: [TestReportAttachment])
    {
        self.uuid = uuid
        self.name = name
        self.description = description
        self.type = type
        self.status = status
        self.steps = steps
        self.startDate = startDate
        self.stopDate = stopDate
        self.attachments = attachments
    }
}
