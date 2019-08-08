import MixboxReporting
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxGray

final class IpcRouterHolder: IpcRouterProvider {
    var ipcRouter: IpcRouter?
}

final class TestCaseUtils: IpcRouterProvider {
    // Internal in TestCase
    
    let pageObjects: PageObjects
    let permissions: ApplicationPermissionsSetter
    let legacyNetworking: LegacyNetworking
    let photoStubber: PhotoStubber
    var ipcRouter: IpcRouter? {
        get {
            return ipcRouterHolder.ipcRouter
        }
        set {
            ipcRouterHolder.ipcRouter = newValue
        }
    }
    private let ipcRouterHolder = IpcRouterHolder()
    
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
            photoSaver: PhotoSaverImpl(
                runLoopSpinnerLockFactory: RunLoopSpinnerLockFactoryImpl(
                    runLoopSpinnerFactory: baseUiTestCaseUtils.runLoopSpinnerFactory
                )
            ),
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder
        )
        
        let compoundBridgedUrlProtocolClass = CompoundBridgedUrlProtocolClass()
        
        let instancesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolInstance & IpcObjectIdentifiable>()
        let classesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolClass & IpcObjectIdentifiable>()
        
        let urlProtocolStubAdder = UrlProtocolStubAdderImpl(
            bridgedUrlProtocolRegisterer: IpcBridgedUrlProtocolRegisterer(
                ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient,
                writeableClassesRepository: classesRepository.toStorable()
            ),
            rootBridgedUrlProtocolClass: compoundBridgedUrlProtocolClass,
            bridgedUrlProtocolClassRepository: compoundBridgedUrlProtocolClass,
            ipcRouterProvider: ipcRouterHolder,
            ipcMethodHandlersRegisterer: NetworkMockingIpcMethodsRegisterer(
                readableInstancesRepository: instancesRepository.toStorable { $0 },
                writeableInstancesRepository: instancesRepository.toStorable(),
                readableClassesRepository: classesRepository.toStorable { $0 },
                ipcClient: baseUiTestCaseUtils.lazilyInitializedIpcClient
            )
        )
        
        let legacyNetworking = GrayBoxLegacyNetworking(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: baseUiTestCaseUtils.testFailureRecorder,
            spinner: baseUiTestCaseUtils.spinner,
            bundleResourcePathProvider: baseUiTestCaseUtils.bundleResourcePathProviderForTestTarget
        )
        
        self.legacyNetworking = legacyNetworking
    }
}
