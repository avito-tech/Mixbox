public final class LegacyNetworkingImpl: LegacyNetworking {
    public let stubbing: LegacyNetworkStubbing
    public let recording: LegacyNetworkRecording
    
    public init(
        stubbing: LegacyNetworkStubbing,
        recording: LegacyNetworkRecording)
    {
        self.stubbing = stubbing
        self.recording = recording
    }
}
