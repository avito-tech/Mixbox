public struct AllureExecutableItem: Encodable {
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
