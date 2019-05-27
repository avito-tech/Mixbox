import MixboxReporting
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxGray

final class TestCaseUtils {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    let permissions: ApplicationPermissionsSetter
    let networking: Networking
    let photoStubber: PhotoStubber
    
    // Private in TestCase
    
    let applicationFrameProvider = GrayApplicationFrameProvider()
    
    let baseUiTestCaseUtils = BaseUiTestCaseUtils()
    private let screenshotTaker: ScreenshotTaker
    
    init() {
        let bundleId = Bundle.main.bundleIdentifier.unwrapOrFail()
        
        let applicationPermissionsSetterFactory = ApplicationPermissionsSetterFactoryImpl(
            notificationsApplicationPermissionSetterFactory: AlwaysFailingNotificationsApplicationPermissionSetterFactory(
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
            ),
            tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactoryImpl(),
            geolocationApplicationPermissionSetterFactory: GeolocationApplicationPermissionSetterFactoryImpl(
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                currentSimulatorFileSystemRootProvider: CurrentApplicationCurrentSimulatorFileSystemRootProvider(),
                spinner: baseUiTestCaseUtils.spinner
            )
        )
        
        permissions = applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: bundleId,
            displayName: ApplicationNameProvider.applicationName,
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        let windowsProvider = WindowsProviderImpl(
            application: UIApplication.shared,
            shouldIncludeStatusBarWindow: true
        )
        
        screenshotTaker = GrayScreenshotTaker(
            windowsProvider: windowsProvider,
            screen: UIScreen.main
        )
        
        let mainRealHierarchy = GrayPageObjectDependenciesFactory(
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
            ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
            stepLogger: baseUiTestCaseUtils.stepLogger,
            pollingConfiguration: .reduceWorkload,
            elementFinder: RealViewHierarchyElementFinder(
                ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                stepLogger: baseUiTestCaseUtils.stepLogger,
                screenshotTaker: screenshotTaker
            ),
            screenshotTaker: screenshotTaker,
            windowsProvider: windowsProvider,
            spinner: baseUiTestCaseUtils.spinner
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
        
        photoStubber = PhotoStubberImpl(
            stubImagesProvider: RedImagesProvider(),
            tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactoryImpl(),
            photoSaver: PhotoSaverImpl(),
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        class NotImplementedNetworkingImpl: Networking {
            var stubbing: NetworkStubbing { grayNotImplemented() }
            var recording: NetworkRecording { grayNotImplemented() }
        }
        
        networking = NotImplementedNetworkingImpl()
    }
}
