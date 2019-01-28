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
            ".+?\\..+?\\.test.*?\\(\\) -> \\(\\)", // XcuiTests.FailuresTests.test_multipleMatchesFailure() -> ()
            ".+?\\..+?\\.parametrizedTest.*?\\(\\)" // XcuiTests.FailuresTests.parametrizedTest() -> ()
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
            stepLogger = StepLoggerImpl()
        } else {
            stepLogger = XcuiActivityStepLogger(originalStepLogger: StepLoggerImpl())
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
        
        let snapshotsComparisonUtility = SnapshotsComparisonUtilityImpl(
            // TODO
            basePath: "/tmp/01A2DABE-6D10-45D7-B48E-4AC1153712A9/UITests/Screenshots"
        )
        
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
        
        let snapshotCaches = SnapshotCachesImpl.create(cachingEnabled: false)
        
        let app: (_ applicationProvider: ApplicationProvider, _ elementFinder: ElementFinder) -> XcuiPageObjectDependenciesFactory = { applicationProvider, elementFinder in
            return XcuiPageObjectDependenciesFactory(
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder,
                ipcClient: lazilyInitializedIpcClient,
                snapshotsComparisonUtility: snapshotsComparisonUtility,
                stepLogger: stepLogger,
                pollingConfiguration: .reduceLatency,
                snapshotCaches: SnapshotCachesImpl.create(cachingEnabled: false),
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                applicationCoordinatesProvider: ApplicationCoordinatesProviderImpl(
                    applicationProvider: applicationProvider
                ),
                eventGenerator: EventGeneratorImpl(
                    applicationProvider: applicationProvider
                )
            )
        }
        
        let xcuiApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: stepLogger,
                    snapshotCaches: snapshotCaches,
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
