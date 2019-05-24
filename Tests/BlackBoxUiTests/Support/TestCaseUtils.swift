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
    let photoStubber: PhotoStubber
    
    var networking: Networking {
        return launchableApplicationProvider.launchableApplication.networking
    }
    
    // Private in TestCase
    
    var ipcRouter: IpcRouter? // Just to store server (to not let him die during test)
    let launchableApplicationProvider: LaunchableApplicationProvider
    let baseUiTestCaseUtils = BaseUiTestCaseUtils()
    
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
            bundleResourcePathProvider: baseUiTestCaseUtils.bundleResourcePathProviderForTestTarget
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
                currentSimulatorFileSystemRootProvider: CurrentApplicationCurrentSimulatorFileSystemRootProvider()
            )
        )
        self.applicationPermissionsSetterFactory = applicationPermissionsSetterFactory

        permissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: XCUIApplication().bundleID,
            displayName: "We don't care at the moment",
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
            photoSaver: PhotoSaverImpl(),
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        let app: (_ applicationProvider: ApplicationProvider, _ elementFinder: ElementFinder, _ ipcClient: IpcClient?) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker, baseUiTestCaseUtils] applicationProvider, elementFinder, ipcClient in
            XcuiPageObjectDependenciesFactory(
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                ipcClient: ipcClient ?? AlwaysFailingIpcClient(),
                stepLogger: baseUiTestCaseUtils.stepLogger,
                pollingConfiguration: .reduceLatency,
                elementFinder: elementFinder,
                applicationProvider: applicationProvider,
                eventGenerator: XcuiEventGenerator(
                    applicationProvider: applicationProvider
                ),
                screenshotTaker: screenshotTaker,
                pasteboard: ipcClient.flatMap { IpcPasteboard(ipcClient: $0) } ?? UikitPasteboard(uiPasteboard: .general)
            )
        }
        
        let xcuiApp: (_ application: @escaping () -> XCUIApplication) -> XcuiPageObjectDependenciesFactory = { [screenshotTaker, baseUiTestCaseUtils] application in
            let provider = ApplicationProviderImpl(closure: application)
            
            return app(
                provider,
                XcuiElementFinder(
                    stepLogger: baseUiTestCaseUtils.stepLogger,
                    applicationProviderThatDropsCaches: provider,
                    screenshotTaker: screenshotTaker
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
                    screenshotTaker: screenshotTaker
                ),
                nil
            )
        }
        
        pageObjects = PageObjects(
            apps: Apps(
                mainRealHierarchy: app(
                    ApplicationProviderImpl { XCUIApplication() },
                    RealViewHierarchyElementFinder(
                        ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
                        testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                        stepLogger: baseUiTestCaseUtils.stepLogger,
                        screenshotTaker: screenshotTaker
                    ),
                    baseUiTestCaseUtils.lazilyInitializedIpcClient
                ),
                mainXcui: xcuiApp { XCUIApplication() },
                settings: thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.Preferences") },
                springboard: thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") }
            )
        )
    }
}
