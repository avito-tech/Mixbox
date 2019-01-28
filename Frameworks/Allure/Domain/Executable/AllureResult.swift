// In Allure it inherits from AllureExecutableItem,
// but inheritance in Swift requires too many boilerplate:
// - Manually implemented Encodable
// - Manually implemented init
public final class AllureResult: Encodable {
    public let uuid: AllureUuid
    public let fullName: String?
    public let historyId: String?
    public let labels: [AllureLabel]
    public let links: [AllureLink]
    
    // AllureExecutableItem:
    public let name: String?
    public let status: AllureStatus
    public let statusDetails: AllureStatusDetails?
    public let stage: AllureResultStage
    public let description: String?
    public let descriptionHtml: String?
    public let steps: [AllureStepResult]
    public let start: AllureTimestamp?
    public let stop: AllureTimestamp?
    public let attachments: [AllureAttachment]
    public let parameters: [AllureParameter]
    
    public init(
        uuid: AllureUuid,
        fullName: String?,
        historyId: String?,
        labels: [AllureLabel],
        links: [AllureLink],
        name: String?,
        status: AllureStatus,
        statusDetails: AllureStatusDetails?,
        stage: AllureResultStage,
        description: String?,
        descriptionHtml: String?,
        steps: [AllureStepResult],
        start: AllureTimestamp?,
        stop: AllureTimestamp?,
        attachments: [AllureAttachment],
        parameters: [AllureParameter])
    {
        self.uuid = uuid
        self.fullName = fullName
        self.historyId = historyId
        self.labels = labels
        self.links = links
        self.name = name
        self.status = status
        self.statusDetails = statusDetails
        self.stage = stage
        self.description = description
        self.descriptionHtml = descriptionHtml
        self.steps = steps
        self.start = start
        self.stop = stop
        self.attachments = attachments
        self.parameters = parameters
    }
}
