public final class AllureTimestamp: Encodable {
    public let epochMilliseconds: Int64
    
    public init(epochMilliseconds: Int64) {
        self.epochMilliseconds = epochMilliseconds
    }
    
    public convenience init(timeInterval: TimeInterval) {
        self.init(epochMilliseconds: Int64(timeInterval * 1000))
    }
    
    public convenience init(date: Date) {
        self.init(timeInterval: date.timeIntervalSince1970)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(epochMilliseconds)
    }
}
