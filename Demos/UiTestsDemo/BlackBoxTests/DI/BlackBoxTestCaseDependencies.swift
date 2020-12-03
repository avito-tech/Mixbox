import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxBlack
import MixboxUiTestsFoundation
import MixboxIpcSbtuiClient
import MixboxIpc
import MixboxDi
import UiTestsSharedCode

final class BlackBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisteres() -> [DependencyCollectionRegisterer] {
        return [
            SingleAppBlackBoxDependencies(),
            UiTestCaseDependencies()
        ]
    }
    
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
    }
}
