import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxXcuiDriver
import SBTUITestTunnel
import MixboxIpcSbtuiClient
import MixboxReporting

public final class SbtuiLaunchableApplication: LaunchableApplication {
    public let networking: Networking
    
    private let tunneledApplication = SBTUITunneledApplication()
    private let applicationDidLaunchObserver: ApplicationDidLaunchObserver
    private let testFailureRecorder: TestFailureRecorder
    private let sbtuiStubApplier: SbtuiStubApplier
    private let sbtuiNetworkRecordsProvider: SbtuiNetworkRecordsProvider
    
    public init(
        applicationDidLaunchObserver: ApplicationDidLaunchObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.applicationDidLaunchObserver = applicationDidLaunchObserver
        self.testFailureRecorder = testFailureRecorder
        self.sbtuiStubApplier = SbtuiStubApplier(
            tunneledApplication: tunneledApplication
        )
        
        sbtuiNetworkRecordsProvider = SbtuiNetworkRecordsProvider(
            tunneledApplication: tunneledApplication,
            testFailureRecorder: testFailureRecorder
        )
        
        let stubRequestBuilder = SbtuiStubRequestBuilder(
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
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
                    stubRequestBuilder: stubRequestBuilder,
                    networkRecordsProvider: sbtuiNetworkRecordsProvider,
                    networkRecorderLifecycle: sbtuiNetworkRecordsProvider,
                    testFailureRecorder: testFailureRecorder
                )
            )
        )
    }
    
    public func launch(environment: [String: String]) -> LaunchedApplication {
        // Note that setting it to a value > Int32.max would lead to an error.
        let timeoutValueThatReallyDisablesTimeout: TimeInterval = 100000
        SBTUITunneledApplication.setConnectionTimeout(timeoutValueThatReallyDisablesTimeout)
        
        for (key, value) in environment {
            tunneledApplication.launchEnvironment[key] = value
        }
        
        tunneledApplication.launchTunnel { [applicationDidLaunchObserver, sbtuiStubApplier, sbtuiNetworkRecordsProvider] in
            applicationDidLaunchObserver.applicationDidLaunch()
            sbtuiStubApplier.handleTunnelIsLaunched()
            sbtuiNetworkRecordsProvider.handleTunnelIsLaunched()
        }
        
        return LaunchedApplicationImpl(
            ipcClient: SbtuiIpcClient(
                application: tunneledApplication
            ),
            ipcRouter: nil
        )
    }
}
