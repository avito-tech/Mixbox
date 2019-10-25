import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit

final class BaseUiTestCaseUtils {
    // Internal in TestCase
    
    let fileSystem: FileSystem
    let waiter: RunLoopSpinningWaiter
    let iosVersionProvider: IosVersionProvider = UiDeviceIosVersionProvider(uiDevice: UIDevice.current)
    
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
            //          BlackBoxUiTests.SwipeActionTouchesTests.(parametrizedTest___swipe___produces_expected_event in _54C65FCCFCCAFE9EE80FC2EC0649E42C)(swipeClosure: (MixboxUiTestsFoundation.ElementWithUi) -> (), startPoint: __C.CGPoint, endPointOffset: __C.CGVector) -> ()
            ".+?\\..+?\\.\\(?parametrizedTest.*? -> \\(\\)",
            
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
    let signpostActivityLogger: SignpostActivityLogger
    let dateProvider = SystemClockDateProvider()
    
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
        
        if #available(iOS 12.0, *) {
            self.signpostActivityLogger = SignpostActivityLoggerImpl(
                signpostLoggerFactory: SignpostLoggerFactoryImpl(),
                subsystem: "mixbox",
                category: "mixbox" // TODO: Find a use for it
            )
        } else {
            self.signpostActivityLogger = DisabledSignpostActivityLogger()
        }
    }
}
