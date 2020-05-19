import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxBlack
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc
import MixboxDi

final class BlackBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisteres() -> [DependencyCollectionRegisterer] {
        return [
            MixboxBlackDependencies(
                mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies(
                    stepLogger: Singletons.stepLogger,
                    enableXctActivityLogging: Singletons.enableXctActivityLogging
                )
            ),
            UiTestCaseDependencies()
        ]
    }
    
    // swiftlint:disable:next function_body_length
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisteres().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: ApplicationFrameProvider.self) { _ in
            XcuiApplicationFrameProvider(
                applicationProvider: ApplicationProviderImpl(
                    closure: {
                        XCUIApplication()
                    }
                )
            )
        }
        di.register(type: ApplicationLifecycleObservableImpl.self) { _ in
            ApplicationLifecycleObservableImpl()
        }
        di.register(type: (ApplicationLifecycleObserver & ApplicationLifecycleObservable).self) { di in
            try di.resolve() as ApplicationLifecycleObservableImpl
        }
        di.register(type: ApplicationLifecycleObserver.self) { di in
            try di.resolve() as ApplicationLifecycleObservableImpl
        }
        di.register(type: ApplicationLifecycleObservable.self) { di in
            try di.resolve() as ApplicationLifecycleObservableImpl
        }
        di.register(scope: .unique, type: LegacyNetworking.self) { di in
            (try di.resolve() as LaunchableApplicationProvider).launchableApplication.legacyNetworking
        }
        di.register(type: LaunchableApplicationProvider.self) { [bundleResourcePathProviderForTestsTarget] di in
            LaunchableApplicationProvider(
                applicationLifecycleObservable: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                bundleResourcePathProvider: bundleResourcePathProviderForTestsTarget,
                waiter: try di.resolve()
            )
        }
        di.register(type: TccDbApplicationPermissionSetterFactory.self) { di in
            // We use fbxtest in Emcee on CI.
            // Fbxctest resets tcc.db on its own (very unfortunately).
            AtApplicationLaunchTccDbApplicationPermissionSetterFactory(
                applicationLifecycleObservable: try di.resolve()
            )
        }
        di.register(type: NotificationsApplicationPermissionSetterFactory.self) { di in
            FakeSettingsAppNotificationsApplicationPermissionSetterFactory(
                fakeSettingsAppBundleId: "mixbox.Tests.FakeSettingsApp",
                testFailureRecorder: try di.resolve()
            )
        }
        
        di.register(type: Apps.self) { di in
            let app: (_ applicationProvider: ApplicationProvider, _ elementFinder: ElementFinder, _ ipcClient: IpcClient?) throws -> XcuiPageObjectDependenciesFactory = { applicationProvider, elementFinder, ipcClient in
                let synchronousIpcClientFactory: SynchronousIpcClientFactory = try di.resolve()
                
                let pasteboard: Pasteboard = ipcClient.map { IpcPasteboard(ipcClient: synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0)) }
                    ?? UikitPasteboard(uiPasteboard: .general)
                
                let ipcClient = ipcClient ?? AlwaysFailingIpcClient()
                let synchronousIpcClient = synchronousIpcClientFactory.synchronousIpcClient(ipcClient: ipcClient)
                
                return XcuiPageObjectDependenciesFactory(
                    testFailureRecorder: try di.resolve(),
                    ipcClient: synchronousIpcClient,
                    stepLogger: try di.resolve(),
                    pollingConfiguration: try di.resolve(),
                    elementFinder: elementFinder,
                    applicationProvider: applicationProvider,
                    eventGenerator: XcuiEventGenerator(
                        applicationProvider: applicationProvider
                    ),
                    screenshotTaker: try di.resolve(),
                    pasteboard: pasteboard,
                    runLoopSpinningWaiter: try di.resolve(),
                    signpostActivityLogger: try di.resolve(),
                    snapshotsDifferenceAttachmentGenerator: try di.resolve(),
                    snapshotsComparatorFactory: try di.resolve(),
                    applicationQuiescenceWaiter: XcuiApplicationQuiescenceWaiter(
                        applicationProvider: applicationProvider
                    ),
                    elementSettingsDefaultsProvider: try di.resolve(),
                    keyboardEventInjector: SynchronousKeyboardEventInjectorImpl(
                        keyboardEventInjector: IpcKeyboardEventInjector(ipcClient: ipcClient),
                        runLoopSpinningWaiter: try di.resolve()
                    )
                )
            }
            
            let xcuiApp: (_ application: @escaping () -> XCUIApplication) throws -> XcuiPageObjectDependenciesFactory = { application in
                let provider = ApplicationProviderImpl(closure: application)
                
                return try app(
                    provider,
                    XcuiElementFinder(
                        stepLogger: try di.resolve(),
                        applicationProviderThatDropsCaches: provider,
                        screenshotTaker: try di.resolve(),
                        dateProvider: try di.resolve()
                    ),
                    try di.resolve()
                )
            }
            
            let thirdPartyApp: (_ application: @escaping () -> XCUIApplication) throws -> XcuiPageObjectDependenciesFactory = { application in
                let provider = ApplicationProviderImpl(closure: application)
                
                return try app(
                    provider,
                    XcuiElementFinder(
                        stepLogger: try di.resolve(),
                        applicationProviderThatDropsCaches: provider,
                        screenshotTaker: try di.resolve(),
                        dateProvider: try di.resolve()
                    ),
                    nil
                )
            }
            
            let mainAppXcuiHierarchy = try xcuiApp { XCUIApplication() }
            
            return Apps(
                mainUiKitHierarchy: try app(
                    ApplicationProviderImpl { XCUIApplication() },
                    UiKitHierarchyElementFinder(
                        ipcClient: try di.resolve(),
                        testFailureRecorder: try di.resolve(),
                        stepLogger: try di.resolve(),
                        screenshotTaker: try di.resolve(),
                        signpostActivityLogger: try di.resolve(),
                        dateProvider: try di.resolve()
                    ),
                    try di.resolve()
                ),
                mainXcuiHierarchy: mainAppXcuiHierarchy,
                mainDefaultHierarchy: mainAppXcuiHierarchy,
                settings: try thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.Preferences") },
                springboard: try thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") }
            )
        }
    }
}
