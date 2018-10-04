import MixboxIpc

// Facade for starting everything for tests, on the side of the app.
// Usage:
//
//  start()
//  handleUiBecomeVisible() // somewhere where you feel your tests can start validate te UI
//
public final class MixboxInAppServices {
    private var router: IpcRouter?
    private var client: IpcClient?
    private var ipcStarter: IpcStarter
    private var commandsForAddingRoutes = [(IpcRouter) -> ()]()
    private let shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool
    
    init(
        ipcStarter: IpcStarter,
        shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool)
    {
        self.ipcStarter = ipcStarter
        self.shouldAddAssertionForCallingIsHiddenOnFakeCell = shouldAddAssertionForCallingIsHiddenOnFakeCell
        
        commandsForAddingRoutes = [
            { router in
                MixboxInAppServices.registerDefaultMethods(router: router)
            }
        ]
    }
    
    public convenience init?(environment: [String: String] = ProcessInfo.processInfo.environment) {
        let ipcStarterOrNil: IpcStarter?
        
        // TODO: Replace env variables with single variable with config
        if environment["MIXBOX_USE_BUILTIN_IPC"] == "true" {
            guard let testRunnerHost = environment["MIXBOX_HOST"] else {
                return nil
            }
            
            guard let testRunnerPort = environment["MIXBOX_PORT"].flatMap({ UInt($0) }) else {
                return nil
            }
            
            ipcStarterOrNil = BuiltinIpcStarter(testRunnerHost: testRunnerHost, testRunnerPort: testRunnerPort)
        } else {
            ipcStarterOrNil = SbtuiIpcStarter()
        }
            
        guard let ipcStarter = ipcStarterOrNil else {
            assertionFailure("Can not start IPC")
            return nil
        }
        
        self.init(
            ipcStarter: ipcStarter,
            shouldAddAssertionForCallingIsHiddenOnFakeCell: environment["MIXBOX_SHOULD_ADD_ASSERTION_FOR_CALLING_IS_HIDDEN_ON_FAKE_CELL"] == "true"
        )
    }
    
    public func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler) {
        if let router = router {
            router.register(methodHandler: methodHandler)
        } else {
            commandsForAddingRoutes.append({ router in
                router.register(methodHandler: methodHandler)
            })
        }
    }
    
    public func start() {
        assert(self.router == nil, "MixboxInAppServices are already started")
        
        let (client, router) = ipcStarter.start(commandsForAddingRoutes: commandsForAddingRoutes)
        
        self.router = client
        self.client = router
        
        AccessibilityEnchancer.takeOff(
            shouldAddAssertionForCallingIsHiddenOnFakeCell: shouldAddAssertionForCallingIsHiddenOnFakeCell
        )
    }
    
    private static func registerDefaultMethods(router: IpcRouter) {
        router.register(methodHandler: ScrollingHintIpcMethodHandler())
        router.register(methodHandler: PercentageOfVisibleAreaIpcMethodHandler())
        router.register(methodHandler: VeiwHierarchyIpcMethodHandler())
        
        router.register(methodHandler: OpenUrlIpcMethodHandler())
        
        router.register(methodHandler: PushNotificationIpcMethodHandler())
        
        router.register(methodHandler: SimulateLocationIpcMethodHandler())
        router.register(methodHandler: StopLocationSimulationIpcMethodHandler())
        
        router.register(
            methodHandler: InjectKeyboardEventsIpcMethodHandler(
                keyboardEventInjector: KeyboardEventInjectorImpl(application: UIApplication.shared)
            )
        )
    }
    
    public func handleUiBecomeVisible() {
        ipcStarter.handleUiBecomeVisible()
    }
}
