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
    
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let screenshotTaker = XcuiScreenshotTaker()
    private let stepLogger: StepLogger
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
        if ProcessInfo.processInfo.environment["MIXBOX_CI_USES_FBXCTEST"] == "true" {
            // Usage of XCTActivity crashes fbxctest, so we have to not use it.
            stepLogger = Singletons.stepLogger
        } else {
            stepLogger = XcuiActivityStepLogger(originalStepLogger: Singletons.stepLogger)
        }
        self.stepLogger = stepLogger
        
        let testFailureRecorder = XcTestFailureRecorder(
            currentTestCaseProvider: AutomaticCurrentTestCaseProvider()
        )
        self.testFailureRecorder = testFailureRecorder
        
        let interactionExecutionLogger = InteractionExecutionLoggerImpl(
            stepLogger: stepLogger,
            screenshotTaker: screenshotTaker,
            imageHashCalculator: DHashV0ImageHashCalculator()
        )
        self.interactionExecutionLogger = interactionExecutionLogger
        
        let applicationPermissionsSetterFactory = ApplicationPermissionsSetterFactory(
            // TODO: Tests & demo:
            notificationsApplicationPermissionSetterFactory: AlwaysFailingNotificationsApplicationPermissionSetterFactory(
                testFailureRecorder: testFailureRecorder
            ),
            tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactoryImpl()
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
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder,
                ipcClient: lazilyInitializedIpcClient,
                stepLogger: stepLogger,
                pollingConfiguration: .reduceLatency,
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                applicationCoordinatesProvider: ApplicationCoordinatesProviderImpl(
                    applicationProvider: applicationProvider
                ),
                eventGenerator: EventGeneratorImpl(
                    applicationProvider: applicationProvider
                ),
                screenshotTaker: screenshotTaker
            )
        }
        
        let xcuiApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: stepLogger,
                    applicationProviderThatDropsCaches: provider
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
