import MixboxFoundation
import MixboxTestsFoundation
import MixboxReporting

public final class NetworkAutomaticRecorderAndReplayerProviderImpl:
    NetworkAutomaticRecorderAndReplayerProvider
{
    private let automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProvider
    private let stubRequestBuilder: StubRequestBuilder
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkRecorderLifecycle: NetworkRecorderLifecycle
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProvider,
        stubRequestBuilder: StubRequestBuilder,
        networkRecordsProvider: NetworkRecordsProvider,
        networkRecorderLifecycle: NetworkRecorderLifecycle,
        testFailureRecorder: TestFailureRecorder)
    {
        self.automaticRecorderAndReplayerCreationSettingsProvider = automaticRecorderAndReplayerCreationSettingsProvider
        self.stubRequestBuilder = stubRequestBuilder
        self.networkRecordsProvider = networkRecordsProvider
        self.networkRecorderLifecycle = networkRecorderLifecycle
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
    {
        let creationSettings = automaticRecorderAndReplayerCreationSettingsProvider
            .automaticRecorderAndReplayerCreationSettings(session: session)
        
        switch creationSettings {
        case .failWithError(let error):
            testFailureRecorder.recordUnavoidableFailure(
                description: error
            )
        case .createForRecording(let recordedNetworkSessionPath):
            return RecordingNetworkPlayer(
                networkRecordsProvider: networkRecordsProvider,
                networkRecorderLifecycle: networkRecorderLifecycle,
                testFailureRecorder: testFailureRecorder,
                recordedNetworkSessionPath: recordedNetworkSessionPath
            )
        case .createForReplaying(let recordedNetworkSession):
            return ReplayingNetworkPlayer(
                recordedNetworkSession: recordedNetworkSession,
                stubRequestBuilder: stubRequestBuilder,
                testFailureRecorder: testFailureRecorder
            )
        }
    }
}
