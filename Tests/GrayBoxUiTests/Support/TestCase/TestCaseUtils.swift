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
    
    let baseUiTestCaseUtils = BaseUiTestCaseUtils()
    private let screenshotTaker: ScreenshotTaker
    
    init() {
        let bundleId = Bundle.main.bundleIdentifier.unwrapOrFail()
        
        permissions = applicationPermissionsSetter(
            bundleId: bundleId,
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
            pollingConfiguration: .reduceLatency,
            elementFinder: RealViewHierarchyElementFinder(
                ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
                testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
                stepLogger: baseUiTestCaseUtils.stepLogger,
                screenshotTaker: screenshotTaker
            ),
            screenshotTaker: screenshotTaker,
            windowsProvider: windowsProvider
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

// TODO: Reuse factory
private func applicationPermissionsSetter(
    bundleId: String,
    testFailureRecorder: TestFailureRecorder)
    -> ApplicationPermissionsSetter
{
    let currentSimulatorFileSystemRootProvider = CurrentApplicationCurrentSimulatorFileSystemRootProvider()
    
    func tccDbApplicationPermissionSetter(_ service: TccService) -> ApplicationPermissionSetter {
        return TccDbApplicationPermissionSetter(
            service: service,
            testFailureRecorder: testFailureRecorder,
            tccPrivacySettingsManager: TccPrivacySettingsManagerImpl(
                bundleId: bundleId,
                tccDbFinder: TccDbFinderImpl(
                    currentSimulatorFileSystemRootProvider: currentSimulatorFileSystemRootProvider
                )
            )
        )
    }
    
    let geo = GeolocationApplicationPermissionSetterFactoryImpl(
        testFailureRecorder: testFailureRecorder,
        currentSimulatorFileSystemRootProvider: currentSimulatorFileSystemRootProvider
    )
    
    return ApplicationPermissionsSetterImpl(
        notifications: AlwaysFailingApplicationPermissionWithoutNotDeterminedStateSetter(
            testFailureRecorder: testFailureRecorder
        ),
        geolocation: geo.geolocationApplicationPermissionSetter(bundleId: bundleId),
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
