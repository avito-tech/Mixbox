import MixboxReporting
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxGray

// Сборник утилок для TestCase с их настройками. Может сильно вырасти.
final class TestCaseUtils {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    let permissions: ApplicationPermissionsSetter
    
    // Private in TestCase
    
    let testFailureRecorder: TestFailureRecorder
    let lazilyInitializedIpcClient: IpcClient
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
    
    private let screenshotTaker: ScreenshotTaker
    private let stepLogger: StepLogger
    
    init() {
        let ipcClient = SameProcessIpcClient()
        self.lazilyInitializedIpcClient = ipcClient
        
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
        
        let bundleId = Bundle.main.bundleIdentifier.unwrapOrFail()
        
        permissions = applicationPermissionsSetter(
            bundleId: bundleId,
            testFailureRecorder: testFailureRecorder
        )
        
        screenshotTaker = GrayScreenshotTaker(
            windowsProvider: WindowsProviderImpl(
                application: UIApplication.shared,
                shouldIncludeStatusBarWindow: true
            ),
            screen: UIScreen.main
        )
        
        let mainRealHierarchy = GrayPageObjectDependenciesFactory(
            testFailureRecorder: testFailureRecorder,
            ipcClient: ipcClient,
            stepLogger: stepLogger,
            pollingConfiguration: .reduceLatency,
            elementFinder: RealViewHierarchyElementFinder(
                ipcClient: ipcClient,
                testFailureRecorder: testFailureRecorder,
                stepLogger: stepLogger,
                screenshotTaker: screenshotTaker
            ),
            eventGenerator: GrayEventGenerator(),
            screenshotTaker: screenshotTaker
        )
        
        pageObjects = PageObjects(
            apps: Apps(
                mainRealHierarchy: mainRealHierarchy,
                // TODO: This is wrong!
                mainXcui: mainRealHierarchy,
                settings: mainRealHierarchy,
                springboard: mainRealHierarchy
            )
        )
    }
}

private func applicationPermissionsSetter(
    bundleId: String,
    testFailureRecorder: TestFailureRecorder)
    -> ApplicationPermissionsSetter
{
    func tccDbApplicationPermissionSetter(_ service: TccService) -> ApplicationPermissionSetter {
        return applicationPermissionSetter(
            service: service,
            bundleId: bundleId,
            testFailureRecorder: testFailureRecorder
        )
    }
    
    return ApplicationPermissionsSetterImpl(
        notifications: AlwaysFailingApplicationPermissionWithoutNotDeterminedStateSetter(
            testFailureRecorder: testFailureRecorder
        ),
        geolocation: GeolocationApplicationPermissionSetter(
            bundleId: bundleId
        ),
        calendar: tccDbApplicationPermissionSetter(.calendar),
        camera: tccDbApplicationPermissionSetter(.camera),
        mso: tccDbApplicationPermissionSetter(.mso),
        mediaLibrary: tccDbApplicationPermissionSetter(.mediaLibrary),
        microphone: tccDbApplicationPermissionSetter(.microphone),
        motion: tccDbApplicationPermissionSetter(.motion),
        photos: tccDbApplicationPermissionSetter(.photos),
        reminders: tccDbApplicationPermissionSetter(.reminders),
        siri: tccDbApplicationPermissionSetter(.siri),
        willow: tccDbApplicationPermissionSetter(.willow),
        addressBook: tccDbApplicationPermissionSetter(.addressBook),
        bluetoothPeripheral: tccDbApplicationPermissionSetter(.bluetoothPeripheral),
        calls: tccDbApplicationPermissionSetter(.calls),
        facebook: tccDbApplicationPermissionSetter(.facebook),
        keyboardNetwork: tccDbApplicationPermissionSetter(.keyboardNetwork),
        liverpool: tccDbApplicationPermissionSetter(.liverpool),
        shareKit: tccDbApplicationPermissionSetter(.shareKit),
        sinaWeibo: tccDbApplicationPermissionSetter(.sinaWeibo),
        speechRecognition: tccDbApplicationPermissionSetter(.speechRecognition),
        tencentWeibo: tccDbApplicationPermissionSetter(.tencentWeibo),
        twitter: tccDbApplicationPermissionSetter(.twitter),
        ubiquity: tccDbApplicationPermissionSetter(.ubiquity)
    )
}

private func applicationPermissionSetter(
    service: TccService,
    bundleId: String,
    testFailureRecorder: TestFailureRecorder)
    -> ApplicationPermissionSetter
{
    return TccDbApplicationPermissionSetter(
        service: service,
        bundleId: bundleId,
        testFailureRecorder: testFailureRecorder
    )
}
