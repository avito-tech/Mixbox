import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxBlack
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc

// DI for TestCase.
final class TestCaseUtils {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    let permissions: ApplicationPermissionsSetter
    let testRunnerPermissions: ApplicationPermissionsSetter
    let photoStubber: PhotoStubber
    
    var legacyNetworking: LegacyNetworking {
        return launchableApplicationProvider.launchableApplication.legacyNetworking
    }
    
    // Private in TestCase
    
    var ipcRouter: IpcRouter? // Just to store server (to not let him die during test)
    let launchableApplicationProvider: LaunchableApplicationProvider
    let baseUiTestCaseUtils = BaseUiTestCaseUtils()
    
    let applicationFrameProvider = XcuiApplicationFrameProvider(applicationProvider: ApplicationProviderImpl(closure: { () -> XCUIApplication in
        XCUIApplication()
    }))
    
    private let applicationLifecycleObservableImpl = ApplicationLifecycleObservableImpl()
    private let screenshotTaker = XcuiScreenshotTaker()
    private let applicationPermissionsSetterFactory: ApplicationPermissionsSetterFactory
    
    private let mixboxHelperClient = MixboxHelperClient()
    
    // swiftlint:disable:next function_body_length
    init() {
        // TODO: Implement Mixbox Helper
        // mixboxHelperClient.start()
        // CFRunLoopRun()
        
        launchableApplicationProvider = LaunchableApplicationProvider(
            applicationLifecycleObservable: applicationLifecycleObservableImpl,
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
            bundleResourcePathProvider: baseUiTestCaseUtils.bundleResourcePathProviderForTestTarget,
            waiter: baseUiTestCaseUtils.waiter
        )
        
        let tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory
        
        if baseUiTestCaseUtils.mixboxCiUsesFbxctest {
            // Fbxctest resets tcc.db on its own (very unfortunately)
            // TODO: Test both branches of this `if`
            tccDbApplicationPermissionSetterFactory = AtApplicationLaunchTccDbApplicationPermissionSetterFactory(
                applicationLifecycleObservable: applicationLifecycleObservableImpl
            )
        } else {
            tccDbApplicationPermissionSetterFactory = TccDbApplicationPermissionSetterFactoryImpl()
        }
        
        let applicationPermissionsSetterFactory = ApplicationPermissionsSetterFactoryImpl(
            notificationsApplicationPermissionSetterFactory: FakeSettingsAppNotificationsApplicationPermissionSetterFactory(
                fakeSettingsAppBundleId: "mixbox.Tests.FakeSettingsApp",
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
            ),
            tccDbApplicationPermissionSetterFactory: tccDbApplicationPermissionSetterFactory,
            geolocationApplicationPermissionSetterFactory: GeolocationApplicationPermissionSetterFactoryImpl(
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                currentSimulatorFileSystemRootProvider: CurrentApplicationCurrentSimulatorFileSystemRootProvider(),
                waiter: baseUiTestCaseUtils.waiter,
                iosVersionProvider: baseUiTestCaseUtils.iosVersionProvider
            )
        )
        self.applicationPermissionsSetterFactory = applicationPermissionsSetterFactory

        permissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: XCUIApplication().bundleID,
            displayName: ApplicationNameProvider.applicationName,
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        testRunnerPermissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            // swiftlint:disable:next force_unwrapping
            bundleId: Bundle.main.bundleIdentifier!,
            displayName: "We don't care at the moment",
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        photoStubber = PhotoStubberImpl(
            stubImagesProvider: RedImagesProvider(),
            tccDbApplicationPermissionSetterFactory: tccDbApplicationPermissionSetterFactory,
            photoSaver: PhotoSaverImpl(
                runLoopSpinnerLockFactory: RunLoopSpinnerLockFactoryImpl(
                    runLoopSpinnerFactory: baseUiTestCaseUtils.runLoopSpinnerFactory
                ),
                iosVersionProvider: baseUiTestCaseUtils.iosVersionProvider
            ),
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        let app: (_ applicationProvider: ApplicationProvider, _ elementFinder: ElementFinder, _ ipcClient: IpcClient?) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker, baseUiTestCaseUtils] applicationProvider, elementFinder, ipcClient in
            XcuiPageObjectDependenciesFactory(
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                ipcClient: ipcClient ?? AlwaysFailingIpcClient(),
                stepLogger: baseUiTestCaseUtils.stepLogger,
                pollingConfiguration: .reduceWorkload,
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                eventGenerator: XcuiEventGenerator(
                    applicationProvider: applicationProvider
                ),
                screenshotTaker: screenshotTaker,
                pasteboard: ipcClient.flatMap { IpcPasteboard(ipcClient: $0) } ?? UikitPasteboard(uiPasteboard: .general),
                waiter: baseUiTestCaseUtils.waiter,
                signpostActivityLogger: baseUiTestCaseUtils.signpostActivityLogger,
                snapshotsDifferenceAttachmentGenerator: baseUiTestCaseUtils.snapshotsDifferenceAttachmentGenerator,
                snapshotsComparatorFactory: baseUiTestCaseUtils.snapshotsComparatorFactory
            )
        }
        
        let xcuiApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker, baseUiTestCaseUtils] application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: baseUiTestCaseUtils.stepLogger,
                    applicationProviderThatDropsCaches: provider,
                    screenshotTaker: screenshotTaker,
                    dateProvider: baseUiTestCaseUtils.dateProvider
                ),
                baseUiTestCaseUtils.lazilyInitializedIpcClient
            )
        }
        
        let thirdPartyApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker, baseUiTestCaseUtils] application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: baseUiTestCaseUtils.stepLogger,
                    applicationProviderThatDropsCaches: provider,
                    screenshotTaker: screenshotTaker,
                    dateProvider: baseUiTestCaseUtils.dateProvider
                ),
                nil
            )
        }
        
        let mainAppXcuiHierarchy = xcuiApp { XCUIApplication() }
        
        pageObjects = PageObjects(
            apps: Apps(
                mainUiKitHierarchy: app(
                    ApplicationProviderImpl { XCUIApplication() },
                    UiKitHierarchyElementFinder(
                        ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
                        testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                        stepLogger: baseUiTestCaseUtils.stepLogger,
                        screenshotTaker: screenshotTaker,
                        signpostActivityLogger: baseUiTestCaseUtils.signpostActivityLogger,
                        dateProvider: baseUiTestCaseUtils.dateProvider
                    ),
                    baseUiTestCaseUtils.lazilyInitializedIpcClient
                ),
                mainXcuiHierarchy: mainAppXcuiHierarchy,
                mainDefaultHierarchy: mainAppXcuiHierarchy,
                settings: thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.Preferences") },
                springboard: thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") }
            )
        )
    }
}
