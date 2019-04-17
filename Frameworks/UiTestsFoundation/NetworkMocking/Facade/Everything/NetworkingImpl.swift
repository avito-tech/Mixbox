public final class NetworkingImpl: Networking {
    public let stubbing: NetworkStubbing
    public let recording: NetworkRecording
    
    public init(
        stubbing: NetworkStubbing,
        recording: NetworkRecording)
    {
        self.stubbing = stubbing
        self.recording = recording
    }
}
