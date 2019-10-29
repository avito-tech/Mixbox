import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxGray
import MixboxFoundation
import MixboxDi

final class GrayBoxTestCaseDependencies: DependencyCollectionRegisterer {
    private let bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider
    
    init(bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider) {
        self.bundleResourcePathProviderForTestsTarget = bundleResourcePathProviderForTestsTarget
    }
    
    private func nestedRegisteres() -> [DependencyCollectionRegisterer] {
        return [
            MixboxGrayDependencies(
                mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies(
                    stepLogger: Singletons.stepLogger,
                    enableXctActivityLogging: Singletons.enableXctActivityLogging
                )
            ),
            UiTestCaseDependencies()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisteres().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: IpcRouterHolder.self) { _ in
            IpcRouterHolder()
        }
        di.register(type: IpcRouterProvider.self) { di in
            try di.resolve() as IpcRouterHolder
        }
        di.register(type: Apps.self) { di in
            let mainUiKitHierarchy: PageObjectDependenciesFactory = try di.resolve()
            return Apps(
                mainUiKitHierarchy: mainUiKitHierarchy,
                mainXcuiHierarchy: mainUiKitHierarchy, // TODO: This is wrong! Add Fake object that produces errors for function calls.
                mainDefaultHierarchy: mainUiKitHierarchy,
                settings: mainUiKitHierarchy, // TODO: This is wrong!
                springboard: mainUiKitHierarchy // TODO: This is wrong!
            )
        }
        
        di.register(type: CompoundBridgedUrlProtocolClass.self) { _ in
            CompoundBridgedUrlProtocolClass()
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
        di.register(type: LegacyNetworking.self) { [bundleResourcePathProviderForTestsTarget] di in
            GrayBoxLegacyNetworking(
                urlProtocolStubAdder: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                waiter: try di.resolve(),
                bundleResourcePathProvider: bundleResourcePathProviderForTestsTarget
            )
        }
    }
}
