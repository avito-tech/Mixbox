public final class AllureLabel: Encodable {
    public let name: AllureLabelName
    public let value: String
    
    public init(
        name: AllureLabelName,
        value: String)
    {
        self.name = name
        self.value = value
    }
}
