import MixboxSBTUITestTunnelClient
import MixboxTestsFoundation
import MixboxBlack
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc
import MixboxDi
import TestsIpc

final class BlackBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            SingleMainAppBlackBoxDependencies(),
            UiTestCaseDependencies()
        ]
    }
    
    // swiftlint:disable:next function_body_length
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
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
                waiter: try di.resolve(),
                performanceLogger: try di.resolve(),
                bundleId: "mixbox.Tests.TestedApp"
            )
        }
        di.register(type: TccDbApplicationPermissionSetterFactory.self) { di in
            // We use fbxtest in Emcee on CI.
            // Fbxctest resets tcc.db on its own (very unfortunately).
            AtApplicationLaunchTccDbApplicationPermissionSetterFactory(
                applicationLifecycleObservable: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                tccDbFactory: try di.resolve()
            )
        }
        di.register(type: NotificationsApplicationPermissionSetterFactory.self) { di in
            FakeSettingsAppNotificationsApplicationPermissionSetterFactory(
                fakeSettingsAppBundleId: "mixbox.Tests.FakeSettingsApp",
                testFailureRecorder: try di.resolve()
            )
        }
        
        di.register(type: Apps.self) { di in
            func app(
                applicationProvider: @escaping (DependencyResolver) throws -> ApplicationProvider,
                elementFinder: @escaping (DependencyResolver) throws -> ElementFinder,
                ipcClient: @escaping (DependencyResolver) throws -> IpcClient
            ) throws -> XcuiPageObjectDependenciesFactory {
                XcuiPageObjectDependenciesFactory(
                    dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                    dependencyInjectionFactory: try di.resolve(),
                    ipcClient: ipcClient,
                    elementFinder: elementFinder,
                    applicationProvider: applicationProvider
                )
            }
            
            func thirdPartyApp(
                application: @escaping () -> XCUIApplication
            ) throws -> XcuiPageObjectDependenciesFactory {
                let provider = ApplicationProviderImpl(closure: application)
                
                return try app(
                    applicationProvider: { _ in provider },
                    elementFinder: { di in
                        try XcuiElementFinder(
                            applicationProviderThatDropsCaches: provider,
                            resolvedElementQueryLogger: di.resolve(),
                            assertionFailureRecorder: di.resolve()
                        )
                    },
                    ipcClient: { _ in AlwaysFailingIpcClient() }
                )
            }
            
            let mainApplicationProvider = ApplicationProviderImpl { XCUIApplication() }
            
            // See WORKAROUND in `BlackBoxApplicationDependentDependencyCollectionRegisterer` near:
            // `di.register(type: PageObjectDependenciesFactory.self) { di in`.
            let mainAppIpcClientFactory: (DependencyResolver) throws -> IpcClient = { [parentDi = di] _ in
                try parentDi.resolve()
            }
            
            let mainUiKitHierarchy = try app(
                applicationProvider: { _ in mainApplicationProvider },
                elementFinder: { di in
                    try IpcUiKitHierarchyElementFinder(
                        ipcClient: di.resolve(),
                        performanceLogger: di.resolve(),
                        resolvedElementQueryLogger: di.resolve()
                    )
                },
                ipcClient: mainAppIpcClientFactory
            )
            
            let mainXcuiHierarchy = try app(
                applicationProvider: { _ in mainApplicationProvider },
                elementFinder: { di in
                    try XcuiElementFinder(
                        applicationProviderThatDropsCaches: mainApplicationProvider,
                        resolvedElementQueryLogger: di.resolve(),
                        assertionFailureRecorder: di.resolve()
                    )
                },
                ipcClient: mainAppIpcClientFactory
            )
            
            return Apps(
                mainUiKitHierarchy: mainUiKitHierarchy,
                mainXcuiHierarchy: mainXcuiHierarchy,
                mainDefaultHierarchy: mainXcuiHierarchy,
                settings: try thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.Preferences") },
                springboard: try thirdPartyApp { XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") }
            )
        }
    }
}
