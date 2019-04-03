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
    public let steps: [AllureExecutableItem]
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
        steps: [AllureExecutableItem],
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
    
    public enum CodingKeys: String, CodingKey {
        case uuid
        case fullName
        case historyId
        case labels
        case links
        case name
        case status
        case statusDetails
        case stage
        case description
        case descriptionHtml
        case steps
        case start
        case stop
        case attachments
        case parameters
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(historyId, forKey: .historyId)
        try container.encode(labels, forKey: .labels)
        try container.encode(links, forKey: .links)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encode(statusDetails, forKey: .statusDetails)
        try container.encode(stage, forKey: .stage)
        try container.encode(description, forKey: .description)
        try container.encode(descriptionHtml, forKey: .descriptionHtml)
        try container.encode(steps.map { AnyEncodable($0) }, forKey: .steps)
        try container.encode(start, forKey: .start)
        try container.encode(stop, forKey: .stop)
        try container.encode(attachments, forKey: .attachments)
        try container.encode(parameters, forKey: .parameters)
    }
}
