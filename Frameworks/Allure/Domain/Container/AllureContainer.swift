public final class AllureContainer: Encodable {
    public let uuid: AllureUuid
    public let name: String?
    public let children: [AllureUuid]
    public let description: String?
    public let descriptionHtml: String?
    public let afters: [AllureAfterResult]
    public let befores: [AllureBeforeResult]
    public let links: [AllureLink]
    public let start: AllureTimestamp?
    public let stop: AllureTimestamp?
    
    public init(
        uuid: AllureUuid,
        name: String?,
        children: [AllureUuid],
        description: String?,
        descriptionHtml: String?,
        afters: [AllureAfterResult],
        befores: [AllureBeforeResult],
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
}
