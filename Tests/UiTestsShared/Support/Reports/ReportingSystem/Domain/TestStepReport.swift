import MixboxTestsFoundation
import MixboxFoundation

public final class TestStepReport {
    public let uuid: NSUUID
    public let title: String
    public let status: TestReportStatus
    public let steps: [TestStepReport]
    public let startDate: Date
    public let stopDate: Date
    public let customDataBefore: AnyEquatable
    public let customDataAfter: AnyEquatable?
    public let attachments: [TestReportAttachment]
    
    public init(
        uuid: NSUUID,
        title: String,
        status: TestReportStatus,
        steps: [TestStepReport],
        startDate: Date,
        stopDate: Date,
        customDataBefore: AnyEquatable,
        customDataAfter: AnyEquatable?,
        attachments: [TestReportAttachment])
    {
        self.uuid = uuid
        self.title = title
        self.status = status
        self.steps = steps
        self.startDate = startDate
        self.stopDate = stopDate
        self.customDataBefore = customDataBefore
        self.customDataAfter = customDataAfter
        self.attachments = attachments
    }
}
