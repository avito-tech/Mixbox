import MixboxFoundation
import MixboxTestsFoundation
import MixboxReporting

public final class NetworkAutomaticRecorderAndReplayerProviderImpl:
    NetworkAutomaticRecorderAndReplayerProvider
{
    private let automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProvider
    private let recordedSessionStubber: RecordedSessionStubber
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkRecorderLifecycle: NetworkRecorderLifecycle
    private let testFailureRecorder: TestFailureRecorder
    private let spinner: Spinner
    
    public init(
        automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProvider,
        recordedSessionStubber: RecordedSessionStubber,
        networkRecordsProvider: NetworkRecordsProvider,
        networkRecorderLifecycle: NetworkRecorderLifecycle,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner)
    {
        self.automaticRecorderAndReplayerCreationSettingsProvider = automaticRecorderAndReplayerCreationSettingsProvider
        self.recordedSessionStubber = recordedSessionStubber
        self.networkRecordsProvider = networkRecordsProvider
        self.networkRecorderLifecycle = networkRecorderLifecycle
        self.spinner = spinner
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
                spinner: spinner,
                recordedNetworkSessionPath: recordedNetworkSessionPath
            )
        case .createForReplaying(let recordedNetworkSession):
            return ReplayingNetworkPlayer(
                recordedNetworkSession: recordedNetworkSession,
                recordedSessionStubber: recordedSessionStubber,
                testFailureRecorder: testFailureRecorder
            )
        }
    }
}
