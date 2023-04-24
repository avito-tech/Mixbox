import MixboxSBTUITestTunnelClient
import MixboxUiTestsFoundation
import MixboxTestsFoundation

// TODO: Proper abstraction from SBTMonitoredNetworkRequest
public final class SbtuiNetworkRecordsProvider:
    NetworkRecordsProvider,
    NetworkRecorderLifecycle,
    ApplicationLifecycleObserver
{
    private let testFailureRecorder: TestFailureRecorder
    private let tunneledApplication: SBTUITunneledApplication
    private let requestUrlPattern: String
    
    // MARK: - State
    
    private var recordingShouldBeStarted: Bool = false {
        didSet {
            handleChangeOfStateThatAffectsStartingOfRecording()
        }
    }
    
    private var tunnelWasLaunched: Bool = false {
        didSet {
            handleChangeOfStateThatAffectsStartingOfRecording()
        }
    }
    
    private var recordingWasStarted: Bool = false
    
    public init(
        tunneledApplication: SBTUITunneledApplication,
        testFailureRecorder: TestFailureRecorder,
        applicationLifecycleObservable: ApplicationLifecycleObservable,
        requestUrlPattern: String)
    {
        self.tunneledApplication = tunneledApplication
        self.testFailureRecorder = testFailureRecorder
        self.requestUrlPattern = requestUrlPattern
        
        applicationLifecycleObservable.addObserver(self)
        tunnelWasLaunched = applicationLifecycleObservable.applicationIsLaunched
        
        handleChangeOfStateThatAffectsStartingOfRecording()
    }
    
    // MARK: - ApplicationLifecycleObserver
    
    public func applicationStateChanged(applicationIsLaunched: Bool) {
        tunnelWasLaunched = applicationIsLaunched
    }
    
    // MARK: - NetworkRecordsProvider
    
    public var allRequests: [MonitoredNetworkRequest] {
        if !recordingShouldBeStarted {
            testFailureRecorder.recordFailure(
                description: "`allRequests` is called, but `startRecording()` was not. Call `startRecording()` to be able to get requests",
                shouldContinueTest: true
            )
        }
        
        return tunneledApplication.monitoredRequestsPeekAll().map { $0 as MonitoredNetworkRequest }
    }
    
    // MARK: - NetworkRecorderLifecycle
    
    public func startRecording() {
        recordingShouldBeStarted = true
    }
    
    public func stopRecording() {
        recordingShouldBeStarted = false
    }
    
    // MARK: - Private
    
    private func handleChangeOfStateThatAffectsStartingOfRecording() {
        if tunnelWasLaunched {
            if recordingShouldBeStarted && !recordingWasStarted {
                let requestId = tunneledApplication.monitorRequests(
                    matching: SBTRequestMatch(url: requestUrlPattern)
                )
                
                if requestId == nil {
                    testFailureRecorder.recordFailure(
                        description: "Failed to startRecording: tunneledApplication.monitorRequests returned nil",
                        shouldContinueTest: false
                    )
                    recordingWasStarted = false
                } else {
                    recordingWasStarted = true
                }
            }
            if !recordingShouldBeStarted && recordingWasStarted {
                tunneledApplication.monitorRequestRemoveAll()
                recordingWasStarted = false
            }
        }
    }
}

extension SBTMonitoredNetworkRequest: MonitoredNetworkRequest {
    public func requestJson() -> [String : Any]? {
        return requestJSON()
    }
    
    public func responseJson() -> [String : Any]? {
        return responseJSON()
    }
}
