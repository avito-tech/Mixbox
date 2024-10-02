#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxTestability
import MixboxUiKit
import MixboxIoKit
import MixboxDi

// swiftlint:disable:next type_body_length
public final class InAppServicesDefaultDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            InAppServicesAndGrayBoxSharedDependencyCollectionRegisterer()
        ]
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: InAppServicesStarter.self) { _ in
            InAppServicesStarterImpl()
        }
        di.register(type: ScrollingHintsForViewProvider.self) { di in
            try ScrollingHintsForViewProviderImpl(
                keyboardFrameProvider: di.resolve()
            )
        }
        di.register(type: KeyboardFrameProvider.self) { _ in
            KeyboardFrameProviderImpl()
        }
        di.register(type: LocationSimulationManager.self) { _ in
            LocationSimulationManagerImpl()
        }
        
        registerUtilities(di: di)
        registerIpc(di: di)
        registerEventInjection(di: di)
        registerEventObserving(di: di)
        registerSystemSingletons(di: di)
        registerSwizzling(di: di)
        registerVisibilityCheck(di: di)
        registerLogging(di:di)
        registerPageObjectMakingHelper(di: di)
        registerAccessibilityInitialization(di: di)
        registerSimulatorInitialization(di: di)
    }
    
    // TODO: Fix
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
        di.register(type: UIDevice.self) { _ in
            UIDevice.current
        }
        di.register(type: IosVersionProvider.self) { di in
            UiDeviceIosVersionProvider(
                uiDevice: try di.resolve()
            )
        }
        di.register(type: UserInterfaceIdiomProvider.self) { di in
            UiDeviceUserInterfaceIdiomProvider(
                uiDevice: try di.resolve()
            )
        }
        di.register(type: FloatValuesForSr5346Patcher.self) { di in
            FloatValuesForSr5346PatcherImpl(
                iosVersionProvider: try di.resolve()
            )
        }
        di.register(type: RunLoopSpinnerFactory.self) { di in
            RunLoopSpinnerFactoryImpl(
                runLoopModesStackProvider: try di.resolve()
            )
        }
        di.register(type: RunLoopModesStackProvider.self) { _ in
            RunLoopModesStackProviderImpl()
        }
        di.register(type: RunLoopSpinningWaiter.self) { di in
            RunLoopSpinningWaiterImpl(
                runLoopSpinnerFactory: try di.resolve()
            )
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
            try AccessibilityLabelSwizzlerFactoryImpl(
                allMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory: AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactoryImpl(),
                iosVersionProvider: di.resolve(),
                accessibilityUniqueObjectMap: di.resolve()
            )
        }
        di.register(type: CollectionViewCellSwizzler.self) { di in
            CollectionViewCellSwizzlerImpl(
                assertingSwizzler: try di.resolve()
            )
        }
        di.register(type: CollectionViewSwizzler.self) { di in
            CollectionViewSwizzlerImpl(
                assertingSwizzler: try di.resolve(),
                accessibilityInitializationStatusProvider: try di.resolve()
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
    
    // TODO: Fix linter.
    private func registerVisibilityCheck(di: DependencyRegisterer) {
        di.register(type: ImagePixelDataFromImageCreator.self) { _ in
            ImagePixelDataFromImageCreatorImpl()
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
        di.register(type: NonViewVisibilityChecker.self) { di in
            NonViewVisibilityCheckerImpl(screen: try di.resolve())
        }
    }
    
    private func registerLogging(di: DependencyRegisterer) {
        di.register(type: PerformanceLogger.self) { _ in
            NoopPerformanceLogger()
        }
    }
    
    private func registerPageObjectMakingHelper(di: DependencyRegisterer) {
        di.register(type: PageObjectElementGenerationWizardRunner.self) { di in
            InAppPageObjectElementGenerationWizardRunner(
                applicationWindowsProvider: try di.resolve(),
                uiEventObservableProvider: try di.resolve(),
                viewHierarchyProvider: try di.resolve()
            )
        }
    }
    
    private func registerAccessibilityInitialization(di: DependencyRegisterer) {
        di.register(type: AccessibilityForTestAutomationInitializer.self) { _ in
            NoopAccessibilityForTestAutomationInitializer()
        }
        di.register(type: AccessibilityInitializationStatusProvider.self) { _ in
            AccessibilityInitializationStatusProviderImpl()
        }
    }
    
    private func registerSimulatorInitialization(di: DependencyRegisterer) {
        di.register(type: TextInputFrameworkProvider.self) { di in
            try TextInputFrameworkProviderImpl(
                iosVersionProvider: di.resolve(),
                userInterfaceIdiomProvider: di.resolve()
            )
        }
        di.register(type: SimulatorStateInitializer.self) { di in
            try SimulatorStateInitializerImpl(
                textInputFrameworkProvider: di.resolve()
            )
        }
    }
}

#endif
