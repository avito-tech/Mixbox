import MixboxReporting
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc

final class BaseUiTestCaseUtils {
    // Internal in TestCase
    
    let fileSystem: FileSystem
    let waiter: RunLoopSpinningWaiter
    
    // Private in TestCase
    
    let testFailureRecorder: TestFailureRecorder
    let lazilyInitializedIpcClient: LazilyInitializedIpcClient
    let fileLineForFailureProvider: FileLineForFailureProvider = LastCallOfCurrentTestFileLineForFailureProvider(
        extendedStackTraceProvider: ExtendedStackTraceProviderImpl(
            stackTraceProvider: StackTraceProviderImpl(),
            extendedStackTraceEntryFromCallStackSymbolsConverter: ExtendedStackTraceEntryFromStackTraceEntryConverterImpl()
        ),
        testSymbolPatterns: [
            // Example: TargetName.ClassName.test_withOptionalSuffix() -> ()
            ".+?\\..+?\\.test.*?\\(\\) -> \\(\\)",
            
            // Example: TargetName.ClassName.parametrizedTest_withOptionalSuffix(message: Swift.String) -> ()
            ".+?\\..+?\\.parametrizedTest.*?\\(\\)",
            
            // Example: closure #2 () -> () in TargetName.ClassName.(parametrizedTest in _FA5631F8141319A712430582B52492D9)(fooArg: Swift.String) -> ()
            "\\(parametrizedTest in",
            "\\(test in"
        ]
    )
    let bundleResourcePathProviderForTestTarget: BundleResourcePathProvider
    let stepLogger: StepLogger
    // TODO: Get rid of usage of ProcessInfo singleton here
    let mixboxCiUsesFbxctest = ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] == "true"
    let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    init() {
        self.runLoopSpinnerFactory = RunLoopSpinnerFactoryImpl(
            runLoopModesStackProvider: RunLoopModesStackProviderImpl()
        )
        self.waiter = RunLoopSpinningWaiterImpl(
            runLoopSpinnerFactory: runLoopSpinnerFactory
        )
        
        self.lazilyInitializedIpcClient = LazilyInitializedIpcClient()
        
        let stepLogger: StepLogger
        
        // TODO: Get rid of usage of ProcessInfo singleton here
        let mixboxCiUsesFbxctest = ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] == "true"
        
        if mixboxCiUsesFbxctest {
            // Usage of XCTActivity crashes fbxctest, so we have to not use it.
            stepLogger = Singletons.stepLogger
        } else {
            stepLogger = XcuiActivityStepLogger(originalStepLogger: Singletons.stepLogger)
        }
        
        fileSystem = FileSystemImpl(
            fileManager: FileManager(),
            temporaryDirectoryPathProvider: NsTemporaryDirectoryPathProvider()
        )
        
        self.stepLogger = stepLogger
        
        let testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: AutomaticCurrentTestCaseProvider()
        )
        
        self.testFailureRecorder = testFailureRecorder
        
        self.bundleResourcePathProviderForTestTarget = BundleResourcePathProviderImpl(
            bundle: Bundle(for: TestCaseUtils.self)
        )
    }
}
