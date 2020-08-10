#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability
import MixboxUiKit
import MixboxIoKit
import MixboxDi

public final class InAppServicesDefaultDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        registerUtilities(di: di)
        registerIpc(di: di)
        registerEventInjection(di: di)
        registerEventObserving(di: di)
        registerSystemSingletons(di: di)
        registerSwizzling(di: di)
        registerVisibilityCheck(di: di)
        registerLogging(di:di)
    }
    
    private func registerUtilities(di: DependencyRegisterer) {
        di.registerMultiple { _ in RecordedAssertionFailuresHolder() }
            .reregister { $0 as AssertionFailureRecorder }
            .reregister { $0 as RecordedAssertionFailuresProvider }
        
        di.register(type: Swizzler.self) { _ in
            SwizzlerImpl()
        }
        di.register(type: SwizzlingSynchronization.self) { _ in
            SwizzlingSynchronizationImpl()
        }
        di.register(type: AssertingSwizzler.self) { di in
            AssertingSwizzlerImpl(
                swizzler: try di.resolve(),
                swizzlingSynchronization: try di.resolve(),
                assertionFailureRecorder: try di.resolve()
            )
        }
        di.register(type: IosVersionProvider.self) { _ in
            UiDeviceIosVersionProvider(uiDevice: UIDevice.current)
        }
    }
    
    private func registerIpc(di: DependencyRegisterer) {
        di.register(type: SynchronousIpcClientFactory.self) { _ in
            RunLoopSpinningSynchronousIpcClientFactory(
                runLoopSpinningWaiter: RunLoopSpinningWaiterImpl(
                    runLoopSpinnerFactory: RunLoopSpinnerFactoryImpl(
                        runLoopModesStackProvider: RunLoopModesStackProviderImpl()
                    )
                ),
                timeout: 15
            )
        }
        di.register(type: IpcStarterProvider.self) { di in
            FromEnvironmentIpcStarterProvider(
                synchronousIpcClientFactory: try di.resolve(),
                environmentProvider: try di.resolve(),
                ipcStarterTypeProvider: try di.resolve()
            )
        }
        di.register(type: EnvironmentProvider.self) { di in
            ProcessInfoEnvironmentProvider(
                processInfo: try di.resolve()
            )
        }
        di.register(type: IpcStarterTypeProvider.self) { di in
            FromEnvironmentIpcStarterTypeProvider(
                environmentProvider: try di.resolve()
            )
        }
        di.register(type: MixboxUrlProtocolBootstrapperFactory.self) { di in
            MixboxUrlProtocolBootstrapperFactoryImpl(
                synchronousIpcClientFactory: try di.resolve(),
                ipcStarterTypeProvider: try di.resolve(),
                assertingSwizzler: try di.resolve(),
                assertionFailureRecorder: try di.resolve()
            )
        }
    }
    
    // If we support injecting UI events in MixboxInAppServices, dependencies should be placed here.
    private func registerEventInjection(di: DependencyRegisterer) {
        di.register(type: KeyboardEventInjector.self) { di in
            KeyboardEventInjectorImpl(
                application: try di.resolve(),
                handleHidEventSwizzler: HandleHidEventSwizzlerImpl(
                    assertingSwizzler: try di.resolve()
                )
            )
        }
    }
    
    private func registerEventObserving(di: DependencyRegisterer) {
        di.registerMultiple { _ in UiEventHistoryTracker() }
            .reregister { $0 as UiEventHistoryProvider }
    }
    
    private func registerSystemSingletons(di: DependencyRegisterer) {
        di.register(type: UIScreen.self) { _ in
            UIScreen.main
        }
        di.register(type: UIApplication.self) { _ in
            UIApplication.shared
        }
        di.register(type: ProcessInfo.self) { _ in
            ProcessInfo.processInfo
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func registerSwizzling(di: DependencyRegisterer) {
        di.register(type: ScrollViewIdlingResourceSwizzler.self) { di in
            ScrollViewIdlingResourceSwizzlerImpl(
                assertingSwizzler: try di.resolve()
            )
        }
        di.register(type: UiAnimationIdlingResourceSwizzler.self) { di in
            UiAnimationIdlingResourceSwizzlerImpl(
                assertingSwizzler: try di.resolve(),
                assertionFailureRecorder: try di.resolve()
            )
        }
        di.register(type: ViewControllerIdlingResourceSwizzler.self) { di in
            ViewControllerIdlingResourceSwizzlerImpl(
                assertingSwizzler: try di.resolve()
            )
        }
        di.register(type: CoreAnimationIdlingResourceSwizzler.self) { di in
            CoreAnimationIdlingResourceSwizzlerImpl(
                assertingSwizzler: try di.resolve(),
                assertionFailureRecorder: try di.resolve()
            )
        }
        di.register(type: AccessibilityEnhancer.self) { di in
            let ipcStarterTypeProvider: IpcStarterTypeProvider = try di.resolve()
            let environmentProvider: EnvironmentProvider = try di.resolve()
            
            let ipcStarterType = try ipcStarterTypeProvider.ipcStarterType()
            
             // TODO: Wrong place for this logic
            let shouldEnhanceAccessibilityValue = ipcStarterType != IpcStarterType.graybox
            let shouldEnableFakeCells = (environmentProvider.environment["MIXBOX_SHOULD_ENABLE_FAKE_CELLS"] ?? "true") == "true"
            
            return AccessibilityEnhancerImpl(
                accessibilityLabelSwizzlerFactory: try di.resolve(),
                fakeCellsSwizzling: try di.resolve(),
                shouldEnableFakeCells: shouldEnableFakeCells,
                shouldEnhanceAccessibilityValue: shouldEnhanceAccessibilityValue,
                fakeCellManager: try di.resolve()
            )
        }
        di.register(type: AccessibilityLabelSwizzlerFactory.self) { di in
            AccessibilityLabelSwizzlerFactoryImpl(
                allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactoryImpl(),
                iosVersionProvider: try di.resolve()
            )
        }
        di.register(type: CollectionViewCellSwizzler.self) { di in
            CollectionViewCellSwizzlerImpl(
                assertingSwizzler: try di.resolve()
            )
        }
        di.register(type: CollectionViewSwizzler.self) { di in
            CollectionViewSwizzlerImpl(
                assertingSwizzler: try di.resolve()
            )
        }
        di.register(type: FakeCellsSwizzling.self) { di in
            FakeCellsSwizzlingImpl(
                collectionViewCellSwizzler: try di.resolve(),
                collectionViewSwizzler: try di.resolve()
            )
        }
        di.register(type: FakeCellManager.self) { _ in
            FakeCellManagerImpl()
        }
    }
    
    private func registerVisibilityCheck(di: DependencyRegisterer) {
        di.register(type: ImagePixelDataFromImageCreator.self) { _ in
            ImagePixelDataFromImageCreatorImpl()
        }
        di.register(type: ScreenInContextDrawer.self) { di in
            ScreenInContextDrawerImpl(
                orderedWindowsProvider: OrderedWindowsProviderImpl(
                    applicationWindowsProvider: UiApplicationWindowsProvider(
                        uiApplication: try di.resolve(),
                        iosVersionProvider: try di.resolve()
                    )
                ),
                screen: try di.resolve()
            )
        }
        di.register(type: VisibilityCheckForLoopOptimizerFactory.self) { _ in
            VisibilityCheckForLoopOptimizerFactoryImpl(
                numberOfPointsInGrid: 10000
            )
        }
        di.register(type: ImageFromImagePixelDataCreator.self) { _ in
            ImageFromImagePixelDataCreatorImpl()
        }
        di.register(type: VisibilityCheckImageColorShifter.self) { _ in
            VisibilityCheckImageColorShifterImpl()
        }
        di.register(type: InAppScreenshotTaker.self) { di in
            InAppScreenshotTakerImpl(
                screenInContextDrawer: try di.resolve()
            )
        }
        di.register(type: VisiblePixelDataCalculator.self) { di in
            VisiblePixelDataCalculatorImpl(
                imagePixelDataFromImageCreator: try di.resolve()
            )
        }
        di.register(type: VisibilityCheckImagesCapturer.self) { di in
            VisibilityCheckImagesCapturerImpl(
                imagePixelDataFromImageCreator: try di.resolve(),
                inAppScreenshotTaker: try di.resolve(),
                imageFromImagePixelDataCreator: try di.resolve(),
                screen: try di.resolve(),
                performanceLogger: try di.resolve(),
                visibilityCheckImageColorShifter: try di.resolve()
            )
        }
        di.register(type: ViewVisibilityChecker.self) { di in
            ViewVisibilityCheckerImpl(
                assertionFailureRecorder: try di.resolve(),
                visibilityCheckImagesCapturer: try di.resolve(),
                visiblePixelDataCalculator: try di.resolve(),
                performanceLogger: try di.resolve(),
                visibilityCheckForLoopOptimizerFactory: try di.resolve(),
                screen: try di.resolve()
            )
        }
    }
    
    private func registerLogging(di: DependencyRegisterer) {
        di.register(type: PerformanceLogger.self) { _ in
            NoopPerformanceLogger()
        }
    }
}

#endif
