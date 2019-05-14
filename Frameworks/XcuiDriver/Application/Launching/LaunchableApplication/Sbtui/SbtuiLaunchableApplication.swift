import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import SBTUITestTunnel
import MixboxIpcSbtuiClient
import MixboxReporting

public final class SbtuiLaunchableApplication: LaunchableApplication {
    public let networking: Networking
    
    private let tunneledApplication = SBTUITunneledApplication()
    private let applicationLifecycleObservable: ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let sbtuiStubApplier: SbtuiStubApplier
    private let sbtuiNetworkRecordsProvider: SbtuiNetworkRecordsProvider
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.sbtuiStubApplier = SbtuiStubApplierImpl(
            tunneledApplication: tunneledApplication,
            applicationLifecycleObservable: applicationLifecycleObservable
        )
        
        sbtuiNetworkRecordsProvider = SbtuiNetworkRecordsProvider(
            tunneledApplication: tunneledApplication,
            testFailureRecorder: testFailureRecorder,
            applicationLifecycleObservable: applicationLifecycleObservable
        )
        
        let stubRequestBuilder = SbtuiStubRequestBuilder(
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
        )
        
        let recordedSessionStubber = RecordedSessionStubberImpl(
            stubRequestBuilder: stubRequestBuilder
        )
        
        networking = NetworkingImpl(
            stubbing: NetworkStubbingImpl(
                stubRequestBuilder: stubRequestBuilder
            ),
            recording: NetworkRecordingImpl(
                networkRecordsProvider: sbtuiNetworkRecordsProvider,
                networkRecorderLifecycle: sbtuiNetworkRecordsProvider,
                networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProviderImpl(
                    automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProviderImpl(
                        bundleResourcePathProvider: bundleResourcePathProvider,
                        recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoaderImpl()
                    ),
                    recordedSessionStubber: recordedSessionStubber,
                    networkRecordsProvider: sbtuiNetworkRecordsProvider,
                    networkRecorderLifecycle: sbtuiNetworkRecordsProvider,
                    testFailureRecorder: testFailureRecorder
                )
            )
        )
    }
    
    public func launch(
        arguments: [String],
        environment: [String: String])
        -> LaunchedApplication
    {
        // Note that setting it to a value > Int32.max would lead to an error.
        let timeoutValueThatReallyDisablesTimeout: TimeInterval = 100000
        // Disabling timeout really helps when running tests on CI. On CI everything can be unexpectidly slower.
        // Timeouts really don't work well. One global timeout for a test is enough.
        SBTUITunneledApplication.setConnectionTimeout(timeoutValueThatReallyDisablesTimeout)
        
        var environment = environment
        environment["MIXBOX_IPC_STARTER_TYPE"] = IpcStarterType.sbtui.rawValue
        
        tunneledApplication.launchArguments = arguments
        tunneledApplication.launchEnvironment = environment
        
        tunneledApplication.launchTunnel { [tunneledApplication, applicationLifecycleObservable] in
            applicationLifecycleObservable.applicationStateChanged(applicationIsLaunched: true)
        }
        
        // I do not really know it is neccessary:
        if !tunneledApplication.exists {
            let totalTimeout: TimeInterval = 60
            let attempts = 10
            let timeout: TimeInterval = totalTimeout / TimeInterval(attempts)
            
            for _ in 0..<attempts where !tunneledApplication.waitForExistence(timeout: timeout) {}
        }
        
        return LaunchedApplicationImpl(
            ipcClient: SbtuiIpcClient(
                application: tunneledApplication
            ),
            ipcRouter: nil
        )
    }
    
    public func terminate() {
        tunneledApplication.terminate()
        applicationLifecycleObservable.applicationStateChanged(applicationIsLaunched: false)
    }
}
