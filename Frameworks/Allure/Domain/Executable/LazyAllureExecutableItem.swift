public final class LazyAllureExecutableItem: AllureExecutableItem {
    public let name: String?
    public let status: AllureStatus
    public let statusDetails: AllureStatusDetails?
    public let stage: AllureResultStage
    public let description: String?
    public let descriptionHtml: String?
    public let steps: [AllureExecutableItem]
    public let start: AllureTimestamp?
    public let stop: AllureTimestamp?
    public let lazyAttachments: [LazyLoader<AllureAttachment?>]
    public let parameters: [AllureParameter]
    
    public var attachments: [AllureAttachment] {
        return lazyAttachments.compactMap {
            switch $0.value() {
            case .failure(_):
                return nil
            case .loaded(let value):
                return value
            }
        }
    }
    
    public init(
        name: String?,
        status: AllureStatus,
        statusDetails: AllureStatusDetails?,
        stage: AllureResultStage,
        description: String?,
        descriptionHtml: String?,
        steps: [AllureExecutableItem],
        start: AllureTimestamp?,
        stop: AllureTimestamp?,
        lazyAttachments: [LazyLoader<AllureAttachment?>],
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
        self.lazyAttachments = lazyAttachments
        self.parameters = parameters
    }
    
    public enum CodingKeys: String, CodingKey {
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
