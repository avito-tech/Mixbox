import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxDi

public final class XcuiPageObjectDependenciesFactory: BasePageObjectDependenciesFactory {
    public convenience init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        ipcClient: @escaping (DependencyResolver) throws -> IpcClient,
        elementFinder: @escaping (DependencyResolver) throws -> ElementFinder,
        applicationProvider: @escaping (DependencyResolver) throws -> ApplicationProvider
    ) {
        self.init(
            dependencyResolver: dependencyResolver,
            dependencyInjectionFactory: dependencyInjectionFactory,
            registerAdditionalSpecificDependencies: { di in
                di.register(type: IpcClient.self) { di in
                    try ipcClient(di)
                }
                di.register(type: Pasteboard.self) { di in
                    let synchronousIpcClientFactory: SynchronousIpcClientFactory = try di.resolve()
                    let ipcClient: IpcClient = try di.resolve()
                    
                    return IpcPasteboard(
                        ipcClient: synchronousIpcClientFactory.synchronousIpcClient(
                            ipcClient: ipcClient
                        )
                    )
                }
                di.register(type: ElementFinder.self) { di in
                    try elementFinder(di)
                }
                di.register(type: ApplicationProvider.self) { di in
                    try applicationProvider(di)
                }
            }
        )
    }
        
    public init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        // Note: `ApplicationProvider`, `ElementFinder` and `IpcClient` are not registered by default.
        // `IpcPasteboard` is `UikitPasteboard` by default.
        registerAdditionalSpecificDependencies: (DependencyRegisterer) -> ()
    ) {
        super.init(
            dependencyResolver: dependencyResolver,
            dependencyInjectionFactory: dependencyInjectionFactory,
            registerSpecificDependencies: { di in
                BlackBoxApplicationDependentDependencyCollectionRegisterer().register(dependencyRegisterer: di)
                IpcClientsDependencyCollectionRegisterer().register(dependencyRegisterer: di)
                
                di.register(type: PageObjectElementCoreFactory.self) { di in
                    PageObjectElementCoreFactoryImpl(
                        testFailureRecorder: try di.resolve(),
                        screenshotAttachmentsMaker: try di.resolve(),
                        stepLogger: try di.resolve(),
                        dateProvider: try di.resolve(),
                        elementInteractionDependenciesFactory: {
                            XcuiElementInteractionDependenciesFactory(
                                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                                dependencyInjectionFactory: dependencyInjectionFactory
                            )
                        },
                        performanceLogger: try di.resolve(),
                        interactionFailureDebugger: try di.resolve()
                    )
                }
                di.register(type: SynchronousIpcClient.self) { di in
                    let synchronousIpcClientFactory: SynchronousIpcClientFactory = try di.resolve()
                
                    return synchronousIpcClientFactory.synchronousIpcClient(ipcClient: try di.resolve())
                }
                di.register(type: Pasteboard.self) { _ in
                    UikitPasteboard(uiPasteboard: .general)
                }
                di.register(type: ApplicationScreenshotTaker.self) { di in
                    try XcuiApplicationScreenshotTaker(
                        applicationProvider: di.resolve()
                    )
                }
                di.register(type: ResolvedElementQueryLogger.self) { di in
                    try ResolvedElementQueryLoggerImpl(
                        stepLogger: di.resolve(),
                        dateProvider: di.resolve(),
                        applicationScreenshotTaker: di.resolve(),
                        performanceLogger: di.resolve(),
                        testFailureRecorder: di.resolve()
                    )
                }
                
                registerAdditionalSpecificDependencies(di)
            }
        )
    }
}
