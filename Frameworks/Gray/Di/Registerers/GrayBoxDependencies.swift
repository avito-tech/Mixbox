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
        di.register(type: ApplicationWindowsProvider.self) { di in
            UiApplicationWindowsProvider(
                uiApplication: UIApplication.shared,
                iosVersionProvider: try di.resolve()
            )
        }
        di.register(type: OrderedWindowsProvider.self) { di in
            OrderedWindowsProviderImpl(
                applicationWindowsProvider: try di.resolve()
            )
        }
        di.register(type: ScreenshotTaker.self) { di in
            GrayScreenshotTaker(
                inAppScreenshotTaker: try di.resolve()
            )
        }
        di.register(type: ScreenInContextDrawer.self) { di in
            ScreenInContextDrawerImpl(
                orderedWindowsProvider: try di.resolve(),
                screen: UIScreen.main
            )
        }
        di.register(type: InAppScreenshotTaker.self) { di in
            InAppScreenshotTakerImpl(
                screenInContextDrawer: try di.resolve()
            )
        }
        di.register(type: ElementFinder.self) { di in
            UiKitHierarchyElementFinder(
                ipcClient: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                stepLogger: try di.resolve(),
                screenshotTaker: try di.resolve(),
                performanceLogger: try di.resolve(),
                dateProvider: try di.resolve()
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
        di.register(type: LegacyNetworkStubbing.self) { di in
            LegacyNetworkStubbingImpl(
                urlProtocolStubAdder: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                waiter: try di.resolve(),
                bundleResourcePathProvider: try di.resolve()
            )
        }
        di.register(type: LegacyNetworkRecording.self) { _ in
            NotImplementedLegacyNetworkRecording()
        }
        di.register(type: LegacyNetworking.self) { di in
            LegacyNetworkingImpl(
                stubbing: try di.resolve(),
                recording: try di.resolve()
            )
        }
        di.register(type: PathGestureUtilsFactory.self) { _ in
            PathGestureUtilsFactoryImpl()
        }
    }
}

private class NotImplementedLegacyNetworkRecording: LegacyNetworkRecording {
    
    var allRequests: [MonitoredNetworkRequest] {
        grayNotImplemented()
    }
    
    func player(
        session: RecordedNetworkSessionPath)
        -> NetworkPlayer
    {
        grayNotImplemented()
    }
}
