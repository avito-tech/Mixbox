import MixboxTestsFoundation
import MixboxXcuiDriver
import MixboxReporting

public final class LaunchableApplicationProvider {
    public var shouldCreateLaunchableApplicationWithBuiltinIpc = false
    
    public var launchableApplication: LaunchableApplication {
        return reusedLaunchableApplication()
            ?? createLaunchableApplication()
    }
    
    private let applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver
    private let testFailureRecorder: TestFailureRecorder
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let spinner: Spinner
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable & ApplicationLifecycleObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider,
        spinner: Spinner)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.spinner = spinner
    }
    
    private var launchableApplicationWasCreatedWithBuiltinIpc = false
    private var launchableApplicationOrNil: LaunchableApplication?
    
    private func reusedLaunchableApplication() -> LaunchableApplication? {
        guard let launchableApplication = launchableApplicationOrNil else {
            return nil
        }
        
        guard launchableApplicationWasCreatedWithBuiltinIpc == shouldCreateLaunchableApplicationWithBuiltinIpc else {
            UnavoidableFailure.fail(
                """
                Conflicting settings for creating launchable application. \
                launchableApplicationWasCreatedWithBuiltinIpc: \(launchableApplicationWasCreatedWithBuiltinIpc) \
                shouldCreateLaunchableApplicationWithBuiltinIpc: \(shouldCreateLaunchableApplicationWithBuiltinIpc)
                """
            )
        }
            
        return launchableApplication
    }
    
    private func createLaunchableApplication() -> LaunchableApplication {
        let launchableApplication: LaunchableApplication
        
        if shouldCreateLaunchableApplicationWithBuiltinIpc {
            launchableApplication = BuiltinIpcLaunchableApplication(
                applicationLifecycleObservable: applicationLifecycleObservable
            )
        } else {
            launchableApplication = SbtuiLaunchableApplication(
                applicationLifecycleObservable: applicationLifecycleObservable,
                testFailureRecorder: testFailureRecorder,
                bundleResourcePathProvider: bundleResourcePathProvider,
                spinner: spinner
            )
        }
        
        launchableApplicationOrNil = launchableApplication
        launchableApplicationWasCreatedWithBuiltinIpc = shouldCreateLaunchableApplicationWithBuiltinIpc
        
        return launchableApplication
    }
}
