import MixboxDi
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxInAppServices
import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

public final class GrayBoxDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            InAppServicesAndGrayBoxSharedDependencyCollectionRegisterer(),
            IpcClientsDependencyCollectionRegisterer(),
            ApplicationIndependentUiTestsDependencyCollectionRegisterer(),
            ApplicationIndependentTestsDependencyCollectionRegisterer()
        ]
    }
    
    // swiftlint:disable:next function_body_length
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: ApplicationStateProvider.self) { _ in
            GrayApplicationStateProvider()
        }
        di.register(type: ApplicationFrameProvider.self) { _ in
            GrayApplicationFrameProvider()
        }
        di.registerMultiple(type: GrayScreenshotTaker.self) { di in
            GrayScreenshotTaker(
                inAppScreenshotTaker: try di.resolve()
            )
        }
            .reregister { $0 as ApplicationScreenshotTaker }
            .reregister { $0 as DeviceScreenshotTaker }
        di.register(type: ElementFinder.self) { di in
            try UiKitHierarchyElementFinder(
                viewHierarchyProvider: di.resolve(),
                testFailureRecorder: di.resolve(),
                stepLogger: di.resolve(),
                applicationScreenshotTaker: di.resolve(),
                performanceLogger: di.resolve(),
                dateProvider: di.resolve()
            )
        }
        di.register(type: ApplicationQuiescenceWaiter.self) { di in
            GrayApplicationQuiescenceWaiter(
                waiter: try di.resolve(),
                idlingResource: CompoundIdlingResource(
                    idlingResources: [
                        IdlingResourceObjectTracker.instance,
                        KeyboardIdlingResource()
                    ]
                )
            )
        }
        di.register(type: PageObjectDependenciesFactory.self) { di in
            GrayPageObjectDependenciesFactory(
                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                dependencyInjectionFactory: try di.resolve()
            )
        }
        di.register(type: MultiTouchEventFactory.self) { _ in
            MultiTouchEventFactoryImpl(
                aggregatingTouchEventFactory: AggregatingTouchEventFactoryImpl(),
                fingerTouchEventFactory: FingerTouchEventFactoryImpl()
            )
        }
        di.register(type: EventGenerator.self) { di in
            let pathGestureUtilsFactory: PathGestureUtilsFactory = try di.resolve()
            
            return GrayEventGenerator(
                touchPerformer: try di.resolve(),
                pathGestureUtils: pathGestureUtilsFactory.pathGestureUtils()
            )
        }
        di.register(type: TouchPerformer.self) { di in
            TouchPerformerImpl(
                multiTouchCommandExecutor: try di.resolve()
            )
        }
        di.register(type: MultiTouchCommandExecutor.self) { di in
            MultiTouchCommandExecutorImpl(
                touchInjectorFactory: try di.resolve()
            )
        }
        di.register(type: TouchInjectorFactory.self) { di in
            TouchInjectorFactoryImpl(
                currentAbsoluteTimeProvider: try di.resolve(),
                runLoopSpinnerFactory: try di.resolve(),
                multiTouchEventFactory: try di.resolve()
            )
        }
        di.register(type: CurrentAbsoluteTimeProvider.self) { _ in
            MachCurrentAbsoluteTimeProvider()
        }
        di.register(type: ElementSimpleGesturesProvider.self) { di in
            GrayElementSimpleGesturesProvider(
                touchPerformer: try di.resolve()
            )
        }
        di.register(type: UrlProtocolStubAdder.self) { di in
            let compoundBridgedUrlProtocolClass = CompoundBridgedUrlProtocolClass()
            
            let instancesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolInstance & IpcObjectIdentifiable>()
            let classesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolClass & IpcObjectIdentifiable>()
            
            return UrlProtocolStubAdderImpl(
                bridgedUrlProtocolRegisterer: IpcBridgedUrlProtocolRegisterer(
                    ipcClient: try di.resolve(),
                    writeableClassesRepository: classesRepository.toStorable()
                ),
                rootBridgedUrlProtocolClass: compoundBridgedUrlProtocolClass,
                bridgedUrlProtocolClassRepository: compoundBridgedUrlProtocolClass,
                ipcRouterProvider: try di.resolve(),
                ipcMethodHandlersRegisterer: NetworkMockingIpcMethodsRegisterer(
                    readableInstancesRepository: instancesRepository.toStorable { $0 },
                    writeableInstancesRepository: instancesRepository.toStorable(),
                    readableClassesRepository: classesRepository.toStorable { $0 },
                    ipcClient: try di.resolve()
                )
            )
        }
        di.register(type: LegacyNetworking.self) { di in
            GrayBoxLegacyNetworking(
                urlProtocolStubAdder: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                waiter: try di.resolve(),
                bundleResourcePathProvider: try di.resolve()
            )
        }
        di.register(type: PathGestureUtilsFactory.self) { _ in
            PathGestureUtilsFactoryImpl()
        }
        di.register(type: InteractionSettingsDefaultsProvider.self) { _ in
            InteractionSettingsDefaultsProviderImpl(preset: .grayBox)
        }
        di.register(type: FloatValuesForSr5346Patcher.self) { _ in
            NoopFloatValuesForSr5346Patcher()
        }
        di.register(type: ElementHierarchyDescriptionProvider.self) { di in
            try GrayElementHierarchyDescriptionProvider(
                viewHierarchyProvider: di.resolve()
            )
        }
        di.register(type: TextTyper.self) { di in
            try GrayTextTyper(
                keyboardPrivateApi: di.resolve()
            )
        }
        di.register(type: MenuItemProvider.self) { di in
            try GrayMenuItemProvider(
                elementMatcherBuilder: di.resolve(),
                elementFinder: di.resolve(),
                elementSimpleGesturesProvider: di.resolve(),
                runLoopSpinnerFactory: di.resolve()
            )
        }
    }
}
