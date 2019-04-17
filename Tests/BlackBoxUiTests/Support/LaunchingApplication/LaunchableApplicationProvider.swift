import MixboxTestsFoundation
import MixboxXcuiDriver
import MixboxReporting

public final class LaunchableApplicationProvider {
    public var shouldCreateLaunchableApplicationWithBuiltinIpc = false
    
    public var launchableApplication: LaunchableApplication {
        return reusedLaunchableApplication()
            ?? createLaunchableApplication()
    }
    
    private let applicationDidLaunchObserver: ApplicationDidLaunchObserver
    private let testFailureRecorder: TestFailureRecorder
    private let bundleResourcePathProvider: BundleResourcePathProvider
    
    public init(
        applicationDidLaunchObserver: ApplicationDidLaunchObserver,
        testFailureRecorder: TestFailureRecorder,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.applicationDidLaunchObserver = applicationDidLaunchObserver
        self.testFailureRecorder = testFailureRecorder
        self.bundleResourcePathProvider = bundleResourcePathProvider
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
                applicationDidLaunchObserver: applicationDidLaunchObserver
            )
        } else {
            launchableApplication = SbtuiLaunchableApplication(
                applicationDidLaunchObserver: applicationDidLaunchObserver,
                testFailureRecorder: testFailureRecorder,
                bundleResourcePathProvider: bundleResourcePathProvider
            )
        }
        
        launchableApplicationOrNil = launchableApplication
        launchableApplicationWasCreatedWithBuiltinIpc = shouldCreateLaunchableApplicationWithBuiltinIpc
        
        return launchableApplication
    }
}
