public final class AllureContainer: Encodable {
    public let uuid: AllureUuid
    public let name: String?
    public let children: [AllureUuid]
    public let description: String?
    public let descriptionHtml: String?
    public let afters: [AllureExecutableItem]
    public let befores: [AllureExecutableItem]
    public let links: [AllureLink]
    public let start: AllureTimestamp?
    public let stop: AllureTimestamp?
    
    public init(
        uuid: AllureUuid,
        name: String?,
        children: [AllureUuid],
        description: String?,
        descriptionHtml: String?,
        afters: [AllureExecutableItem],
        befores: [AllureExecutableItem],
        links: [AllureLink],
        start: AllureTimestamp?,
        stop: AllureTimestamp?)
    {
        self.uuid = uuid
        self.name = name
        self.children = children
        self.description = description
        self.descriptionHtml = descriptionHtml
        self.afters = afters
        self.befores = befores
        self.links = links
        self.start = start
        self.stop = stop
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case children
        case description
        case descriptionHtml
        case afters
        case befores
        case links
        case start
        case stop
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(children, forKey: .children)
        try container.encode(description, forKey: .description)
        try container.encode(descriptionHtml, forKey: .descriptionHtml)
        try container.encode(afters.map { AnyEncodable($0) }, forKey: .afters)
        try container.encode(befores.map { AnyEncodable($0) }, forKey: .befores)
        try container.encode(links, forKey: .links)
        try container.encode(start, forKey: .start)
        try container.encode(stop, forKey: .stop)
    }
}
