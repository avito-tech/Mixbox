import SBTUITestTunnel
import MixboxReporting
import MixboxXcuiDriver
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc

// Сборник утилок для TestCase с их настройками. Может сильно вырасти.
final class TestCaseUtils {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    let permissions: ApplicationPermissionsSetter
    let testRunnerPermissions: ApplicationPermissionsSetter
    
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
    var ipcRouter: IpcRouter? // Just to store server (to not let him die during test)
    let fileSystem: FileSystem
    let launchableApplicationProvider: LaunchableApplicationProvider
    let stepLogger: StepLogger
    let bundleResourcePathProviderForTestTarget: BundleResourcePathProvider
    
    private let applicationLifecycleObservableImpl = ApplicationLifecycleObservableImpl()
    private let screenshotTaker = XcuiScreenshotTaker()
    private let applicationPermissionsSetterFactory: ApplicationPermissionsSetterFactory
    
    private let mixboxHelperClient = MixboxHelperClient()
    
    init() {
        // TODO: Implement Mixbox Helper
        // mixboxHelperClient.start()
        // CFRunLoopRun()
        
        let lazilyInitializedIpcClient = LazilyInitializedIpcClient()
        self.lazilyInitializedIpcClient = lazilyInitializedIpcClient
        
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
        
        launchableApplicationProvider = LaunchableApplicationProvider(
            applicationLifecycleObservable: applicationLifecycleObservableImpl,
            testFailureRecorder: testFailureRecorder,
            bundleResourcePathProvider: bundleResourcePathProviderForTestTarget
        )
        
        let tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory
        
        if mixboxCiUsesFbxctest {
            // Fbxctest resets tcc.db on its own (very unfortunately)
            // TODO: Test both branches of this `if`
            tccDbApplicationPermissionSetterFactory = AtApplicationLaunchTccDbApplicationPermissionSetterFactory(
                applicationLifecycleObservable: applicationLifecycleObservableImpl
            )
        } else {
            tccDbApplicationPermissionSetterFactory = TccDbApplicationPermissionSetterFactoryImpl()
        }
        
        let applicationPermissionsSetterFactory = ApplicationPermissionsSetterFactory(
            // TODO: Tests & demo:
            notificationsApplicationPermissionSetterFactory: AlwaysFailingNotificationsApplicationPermissionSetterFactory(
                testFailureRecorder: testFailureRecorder
            ),
            tccDbApplicationPermissionSetterFactory: tccDbApplicationPermissionSetterFactory
        )
        self.applicationPermissionsSetterFactory = applicationPermissionsSetterFactory

        permissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: XCUIApplication().bundleID,
            displayName: "We don't care at the moment",
            testFailureRecorder: testFailureRecorder
        )
        
        testRunnerPermissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            // swiftlint:disable:next force_unwrapping
            bundleId: Bundle.main.bundleIdentifier!,
            displayName: "We don't care at the moment",
            testFailureRecorder: testFailureRecorder
        )
        
        let app: (_ applicationProvider: ApplicationProvider, _ elementFinder: ElementFinder) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker] applicationProvider, elementFinder in
            return XcuiPageObjectDependenciesFactory(
                testFailureRecorder: testFailureRecorder,
                ipcClient: lazilyInitializedIpcClient,
                stepLogger: stepLogger,
                pollingConfiguration: .reduceLatency,
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                applicationCoordinatesProvider: ApplicationCoordinatesProviderImpl(
                    applicationProvider: applicationProvider
                ),
                eventGenerator: XcuiEventGenerator(
                    applicationProvider: applicationProvider
                ),
                screenshotTaker: screenshotTaker
            )
        }
        
        let xcuiApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker] application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: stepLogger,
                    applicationProviderThatDropsCaches: provider,
                    screenshotTaker: screenshotTaker
                )
            )
        }
        
        pageObjects = PageObjects(
            apps: Apps(
                mainRealHierarchy: app(
                    ApplicationProviderImpl { XCUIApplication() },
                    RealViewHierarchyElementFinder(
                        ipcClient: lazilyInitializedIpcClient,
                        testFailureRecorder: testFailureRecorder,
                        stepLogger: stepLogger,
                        screenshotTaker: screenshotTaker
                    )
                ),
                mainXcui: xcuiApp { XCUIApplication() },
                settings: xcuiApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.Preferences") },
                springboard: xcuiApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") }
            )
        )
    }
}
