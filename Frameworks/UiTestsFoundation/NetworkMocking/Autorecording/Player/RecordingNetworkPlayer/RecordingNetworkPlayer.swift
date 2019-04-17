import MixboxFoundation
import MixboxReporting

public final class RecordingNetworkPlayer: NetworkPlayer {
    private let startOnceToken = ThreadUnsafeOnceToken()
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkRecorderLifecycle: NetworkRecorderLifecycle
    private let testFailureRecorder: TestFailureRecorder
    private let recordedNetworkSessionPath: String
    private let recordedStubFromMonitoredNetworkRequestConverter: RecordedStubFromMonitoredNetworkRequestConverter
    private let idForCallOfCheckpointFunctionInserter: IdForCallOfCheckpointFunctionInserter
    private let recordedNetworkSessionWriter: RecordedNetworkSessionWriter
    
    // MARK: - State
    
    private var recordedRequestIndex: Int = 0
    private var buckets = [RecordedStubBucket]()
    
    public init(
        networkRecordsProvider: NetworkRecordsProvider,
        networkRecorderLifecycle: NetworkRecorderLifecycle,
        testFailureRecorder: TestFailureRecorder,
        recordedNetworkSessionPath: String)
    {
        self.networkRecordsProvider = networkRecordsProvider
        self.networkRecorderLifecycle = networkRecorderLifecycle
        self.recordedNetworkSessionPath = recordedNetworkSessionPath
        self.testFailureRecorder = testFailureRecorder
        
        // TODO: DI or am I crazy?
        self.recordedStubFromMonitoredNetworkRequestConverter = RecordedStubFromMonitoredNetworkRequestConverter(
            testFailureRecorder: testFailureRecorder
        )
        self.idForCallOfCheckpointFunctionInserter = IdForCallOfCheckpointFunctionInserter()
        self.recordedNetworkSessionWriter = RecordedNetworkSessionWriter()
    }
    
    deinit {
        try? flush()
    }
    
    public func checkpointImpl(
        id idFromCode: String?,
        fileLine: RuntimeFileLine)
    {
        startOnce()
        
        do {
            try record(
                requests: waitForRequests(),
                id: try manageId(idFromCode: idFromCode, fileLine: fileLine)
            )
        } catch let error {
            testFailureRecorder.recordFailure(
                description: "Failed to record network: \(error)",
                shouldContinueTest: false
            )
        }
    }
    
    private func startOnce() {
        startOnceToken.executeOnce {
            networkRecorderLifecycle.startRecording()
            
            testFailureRecorder.recordFailure(
                description: "Failing test in network recording mode. This is totally fine, expected and will happen every time network is recorded. Once network is recorded, network player switches to replaying mode, so if everything went well, you wouldn't see this failure. Note that this failure prevents you to commit code that is records network.",
                shouldContinueTest: true
            )
        }
    }
    
    private func waitForRequests() -> [MonitoredNetworkRequest] {
        // The most stupid implementation possible. Hope it works.
        
        var requests = networkRecordsProvider.allRequests
        
        for _ in 0..<4 {
            sleep(5)
            let newRequests = networkRecordsProvider.allRequests
            if newRequests.count == requests.count {
                break
            }
            requests = newRequests
        }
        
        return requests
    }
    
    private func manageId(idFromCode: String?, fileLine: RuntimeFileLine) throws -> String {
        if let nonNilId = idFromCode {
            return nonNilId
        } else {
            let id = UUID().uuidString
            try idForCallOfCheckpointFunctionInserter.insertIdForCallOfCheckpointFunction(
                id: id,
                fileLine: fileLine
            )
            return id
        }
    }
    
    private func record(
        requests: [MonitoredNetworkRequest],
        id: String)
        throws
    {
        let recordedStubs = requests
            .suffix(from: recordedRequestIndex)
            .compactMap(recordedStubFromMonitoredNetworkRequestConverter.recordedStub)
        
        buckets.append(
            RecordedStubBucket(
                id: id,
                recordedStubs: recordedStubs
            )
        )
        
        recordedRequestIndex = requests.count
        
        try flush()
    }
    
    private func flush() throws {
        try recordedNetworkSessionWriter.write(
            recordedSession: RecordedNetworkSession(
                buckets: buckets
            ),
            file: recordedNetworkSessionPath
        )
    }
}
