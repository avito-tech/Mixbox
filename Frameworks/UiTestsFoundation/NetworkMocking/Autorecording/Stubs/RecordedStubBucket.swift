public final class RecordedStubBucket: Codable, Equatable {
    public let id: String
    public let recordedStubs: [RecordedStub]
    
    public init(
        id: String,
        recordedStubs: [RecordedStub])
    {
        self.id = id
        self.recordedStubs = recordedStubs
    }
    
    public static func ==(l: RecordedStubBucket, r: RecordedStubBucket) -> Bool {
        return l.id == r.id
            && l.recordedStubs == r.recordedStubs
    }
}
