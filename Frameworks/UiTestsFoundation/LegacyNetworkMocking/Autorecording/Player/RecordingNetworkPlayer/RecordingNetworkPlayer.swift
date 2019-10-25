import MixboxFoundation
import MixboxTestsFoundation

public final class RecordingNetworkPlayer: NetworkPlayer {
    private let startOnceToken = ThreadUnsafeOnceToken<Void>()
    private let networkRecordsProvider: NetworkRecordsProvider
    private let networkRecorderLifecycle: NetworkRecorderLifecycle
    private let testFailureRecorder: TestFailureRecorder
    private let recordedNetworkSessionPath: String
    private let recordedStubFromMonitoredNetworkRequestConverter: RecordedStubFromMonitoredNetworkRequestConverter
    private let idForCallOfCheckpointFunctionInserter: IdForCallOfCheckpointFunctionInserter
    private let recordedNetworkSessionWriter: RecordedNetworkSessionWriter
    private let waiter: RunLoopSpinningWaiter
    private let onStart: () -> ()
    
    // MARK: - State
    
    private var recordedRequestIndex: Int = 0
    private var buckets = [RecordedStubBucket]()
    
    public init(
        networkRecordsProvider: NetworkRecordsProvider,
        networkRecorderLifecycle: NetworkRecorderLifecycle,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        recordedNetworkSessionPath: String,
        onStart: @escaping () -> ())
    {
        self.networkRecordsProvider = networkRecordsProvider
        self.networkRecorderLifecycle = networkRecorderLifecycle
        self.recordedNetworkSessionPath = recordedNetworkSessionPath
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
        self.onStart = onStart
        
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
        } catch {
            testFailureRecorder.recordFailure(
                description: "Failed to record network: \(error)",
                shouldContinueTest: false
            )
        }
    }
    
    private func startOnce() {
        _ = startOnceToken.executeOnce {
            networkRecorderLifecycle.startRecording()
            
            testFailureRecorder.recordFailure(
                description: "Failing test in network recording mode. This is totally fine, expected and will happen every time network is recorded. Once network is recorded, network player switches to replaying mode, so if everything went well, you wouldn't see this failure. Note that this failure prevents you to commit code that is records network.",
                shouldContinueTest: true
            )
            
            onStart()
        }
    }
    
    private func waitForRequests() -> [MonitoredNetworkRequest] {
        // The most stupid implementation possible. Mimics debounce.
        
        var requests = networkRecordsProvider.allRequests
        var sleptAtLeastOnce = false
        
        waiter.wait(
            timeout: 20,
            interval: 5,
            until: { [networkRecordsProvider] in
                let newRequests = networkRecordsProvider.allRequests
                let shouldStop = newRequests.count == requests.count
                
                requests = newRequests
                
                let sleptAtLeastOnceOldValue = sleptAtLeastOnce
                
                sleptAtLeastOnce = true
                
                return shouldStop && sleptAtLeastOnceOldValue
            }
        )
        
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
