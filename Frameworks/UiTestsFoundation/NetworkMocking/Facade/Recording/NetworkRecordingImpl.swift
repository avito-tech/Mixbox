public final class NetworkRecordingImpl: NetworkRecording {
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkRecorderLifecycle: NetworkRecorderLifecycle
    private let networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProvider
    
    public init(
        networkRecordsProvider: NetworkRecordsProvider,
        networkRecorderLifecycle: NetworkRecorderLifecycle,
        networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProvider)
    {
        self.networkRecordsProvider = networkRecordsProvider
        self.networkRecorderLifecycle = networkRecorderLifecycle
        self.networkAutomaticRecorderAndReplayerProvider = networkAutomaticRecorderAndReplayerProvider
    }
    
    // MARK: - NetworkRecordsProvider
    
    public var allRequests: [MonitoredNetworkRequest] {
        return networkRecordsProvider.allRequests
    }
    
    // MARK: - NetworkRecorderLifecycle
    
    public func startRecording() {
        networkRecorderLifecycle.startRecording()
    }
    
    public func stopRecording() {
        networkRecorderLifecycle.stopRecording()
    }
    
    // MARK: - NetworkAutomaticRecorderAndReplayerProvider
    
    public func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
    {
        return networkAutomaticRecorderAndReplayerProvider.player(session: session)
    }
}
