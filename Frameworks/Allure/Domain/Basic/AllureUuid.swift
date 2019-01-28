public final class AllureUuid: Encodable {
    public let string: String
    
    public init(
        string: String)
    {
        self.string = string
    }
    
    public convenience init(
        uuid: NSUUID)
    {
        self.init(
            string: uuid.uuidString
        )
    }
    
    public static func random() -> AllureUuid {
        return AllureUuid(
            uuid: NSUUID()
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
