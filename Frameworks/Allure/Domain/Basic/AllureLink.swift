public final class AllureLink: Encodable {
    public let name: String
    public let url: String
    public let type: String
    
    public init(
        name: String,
        url: String,
        type: String)
    {
        self.name = name
        self.url = url
        self.type = type
    }
}
