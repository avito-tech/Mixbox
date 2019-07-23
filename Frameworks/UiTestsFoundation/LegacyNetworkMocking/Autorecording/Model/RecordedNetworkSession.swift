public final class RecordedNetworkSession: Codable, Equatable {
    public let buckets: [RecordedStubBucket]
    
    public init(
        buckets: [RecordedStubBucket])
    {
        self.buckets = buckets
    }
    
    public static func ==(l: RecordedNetworkSession, r: RecordedNetworkSession) -> Bool {
        return l.buckets == r.buckets
    }
}
