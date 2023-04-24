import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxIpc
import MixboxSBTUITestTunnelClient
import MixboxIpcSbtuiClient
import MixboxFoundation

public final class SbtuiLaunchableApplication: LaunchableApplication {
    public let legacyNetworking: LegacyNetworking
    
    private let tunneledApplication: SBTUITunneledApplication
    private let applicationLifecycleObservable: ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let sbtuiStubApplier: SbtuiStubApplier
    private let networkRecordsProvider: SbtuiNetworkRecordsProvider
    private let performanceLogger: PerformanceLogger
    
    public init(
        tunneledApplication: SBTUITunneledApplication,
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider,
        waiter: RunLoopSpinningWaiter,
        networkReplayingObserver: NetworkReplayingObserver,
        requestUrlPattern: String = ".*",
        performanceLogger: PerformanceLogger)
    {
        self.tunneledApplication = tunneledApplication
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.performanceLogger = performanceLogger
        
        self.sbtuiStubApplier = SbtuiStubApplierImpl(
            tunneledApplication: tunneledApplication,
            applicationLifecycleObservable: applicationLifecycleObservable
        )
        
        self.networkRecordsProvider = SbtuiNetworkRecordsProvider(
            tunneledApplication: tunneledApplication,
            testFailureRecorder: testFailureRecorder,
            applicationLifecycleObservable: applicationLifecycleObservable,
            requestUrlPattern: requestUrlPattern
        )
        
        let stubRequestBuilder = SbtuiStubRequestBuilder(
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
        )
        let recordedSessionStubber = RecordedSessionStubberImpl(
            stubRequestBuilder: stubRequestBuilder
        )
        
        legacyNetworking = LegacyNetworkingImpl(
            stubbing: stubRequestBuilder,
            recording: LegacyNetworkRecordingImpl(
                networkRecordsProvider: networkRecordsProvider,
                networkRecorderLifecycle: networkRecordsProvider,
                networkAutomaticRecorderAndReplayerProvider: NetworkAutomaticRecorderAndReplayerProviderImpl(
                    automaticRecorderAndReplayerCreationSettingsProvider: AutomaticRecorderAndReplayerCreationSettingsProviderImpl(
                        bundleResourcePathProvider: bundleResourcePathProvider,
                        recordedNetworkSessionFileLoader: RecordedNetworkSessionFileLoaderImpl()
                    ),
                    recordedSessionStubber: recordedSessionStubber,
                    networkRecordsProvider: networkRecordsProvider,
                    networkRecorderLifecycle: networkRecordsProvider,
                    testFailureRecorder: testFailureRecorder,
                    waiter: waiter,
                    networkReplayingObserver: networkReplayingObserver
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
        // Disabling timeout really helps when running tests on CI. On CI everything can be unexpectedly slower.
        // Timeouts really don't work well. One global timeout for a test is enough.
        tunneledApplication.connectionTimeout = timeoutValueThatReallyDisablesTimeout
        
        var environment = environment
        environment["MIXBOX_IPC_STARTER_TYPE"] = IpcStarterType.sbtui.rawValue
        
        tunneledApplication.launchArguments = arguments
        tunneledApplication.launchEnvironment = environment
        
        tunneledApplication.launchTunnel { [applicationLifecycleObservable] in
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
            ipcClient: PerformanceLoggingIpcClient(
                ipcClient: SbtuiIpcClient(
                    application: tunneledApplication
                ),
                performanceLogger: performanceLogger
            ),
            ipcRouter: nil
        )
    }
    
    public func terminate() {
        tunneledApplication.terminate()
        applicationLifecycleObservable.applicationStateChanged(applicationIsLaunched: false)
    }
}
