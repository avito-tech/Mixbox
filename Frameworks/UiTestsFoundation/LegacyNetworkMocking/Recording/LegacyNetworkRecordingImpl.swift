public final class LegacyNetworkRecordingImpl: LegacyNetworkRecording {
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProvider
    
    public init(
        networkRecordsProvider: NetworkRecordsProvider,
        networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProvider)
    {
        self.networkRecordsProvider = networkRecordsProvider
        self.networkAutomaticRecorderAndReplayerProvider = networkAutomaticRecorderAndReplayerProvider
    }
    
    // MARK: - NetworkRecordsProvider
    
    public var allRequests: [MonitoredNetworkRequest] {
        return networkRecordsProvider.allRequests
    }
    
    // MARK: - NetworkAutomaticRecorderAndReplayerProvider
    
    public func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
    {
        return networkAutomaticRecorderAndReplayerProvider.player(session: session)
    }
}
