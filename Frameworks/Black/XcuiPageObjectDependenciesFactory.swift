import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxDi

public final class XcuiPageObjectDependenciesFactory: BasePageObjectDependenciesFactory {
    // swiftlint:disable:next function_body_length
    public init(
        dependencyResolver: DependencyResolver,
        dependencyInjectionFactory: DependencyInjectionFactory,
        ipcClient: IpcClient?,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider)
    {
        super.init(
            dependencyResolver: dependencyResolver,
            dependencyInjectionFactory: dependencyInjectionFactory,
            registerSpecificDependencies: { di in
                di.register(type: PageObjectElementCoreFactory.self) { di in
                    PageObjectElementCoreFactoryImpl(
                        testFailureRecorder: try di.resolve(),
                        screenshotAttachmentsMaker: try di.resolve(),
                        stepLogger: try di.resolve(),
                        dateProvider: try di.resolve(),
                        elementInteractionDependenciesFactory: { elementSettings in
                            XcuiElementInteractionDependenciesFactory(
                                elementSettings: elementSettings,
                                dependencyResolver: WeakDependencyResolver(dependencyResolver: di),
                                dependencyInjectionFactory: dependencyInjectionFactory
                            )
                        },
                        performanceLogger: try di.resolve(),
                        interactionFailureDebugger: try di.resolve()
                    )
                }
                di.register(type: ElementFinder.self) { _ in
                    elementFinder
                }
                di.register(type: ApplicationProvider.self) { _ in
                    applicationProvider
                }
                di.register(type: ApplicationQuiescenceWaiter.self) { di in
                    XcuiApplicationQuiescenceWaiter(
                        applicationProvider: try di.resolve()
                    )
                }
                di.register(type: KeyboardEventInjector.self) { di in
                    IpcKeyboardEventInjector(
                        ipcClient: try di.resolve()
                    )
                }
                di.register(type: SynchronousKeyboardEventInjector.self) { di in
                    SynchronousKeyboardEventInjectorImpl(
                        keyboardEventInjector: try di.resolve(),
                        runLoopSpinningWaiter: try di.resolve()
                    )
                }
                di.register(type: SynchronousIpcClient.self) { di in
                    let synchronousIpcClientFactory:  SynchronousIpcClientFactory = try di.resolve()
                
                    return synchronousIpcClientFactory.synchronousIpcClient(ipcClient: try di.resolve())
                }
                di.register(type: IpcClient.self) { _ in
                    ipcClient ?? AlwaysFailingIpcClient()
                }
                di.register(type: EventGenerator.self) { di in
                    XcuiEventGenerator(
                        applicationProvider: try di.resolve()
                    )
                }
                di.register(type: Pasteboard.self) { di in
                    let synchronousIpcClientFactory:  SynchronousIpcClientFactory = try di.resolve()
                    
                    let ipcPasteboard = ipcClient.map {
                        IpcPasteboard(ipcClient: synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0))
                    }
                    
                    return ipcPasteboard ?? UikitPasteboard(uiPasteboard: .general)
                }
                di.register(type: ApplicationCoordinatesProvider.self) { di in
                    ApplicationCoordinatesProviderImpl(
                        applicationProvider: try di.resolve(),
                        applicationFrameProvider: try di.resolve()
                    )
                }
                di.register(type: ApplicationFrameProvider.self) { di in
                    XcuiApplicationFrameProvider(
                        applicationProvider: try di.resolve()
                    )
                }
            }
        )
    }
}
