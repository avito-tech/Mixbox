#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

// Facade for starting everything for tests, on the side of the app.
public final class MixboxInAppServices: IpcRouter {
    private var router: IpcRouter?
    private var client: IpcClient?
    private var ipcStarter: IpcStarter
    private var commandsForAddingRoutes = [(IpcRouter) -> ()]()
    private let shouldEnhanceAccessibilityValue: Bool
    private let shouldEnableFakeCells: Bool
    private let shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool
    
    public init(
        ipcStarter: IpcStarter,
        shouldEnhanceAccessibilityValue: Bool,
        shouldEnableFakeCells: Bool,
        shouldAddAssertionForCallingIsHiddenOnFakeCell: Bool)
    {
        self.ipcStarter = ipcStarter
        self.shouldEnhanceAccessibilityValue = shouldEnhanceAccessibilityValue
        self.shouldEnableFakeCells = shouldEnableFakeCells
        self.shouldAddAssertionForCallingIsHiddenOnFakeCell = shouldAddAssertionForCallingIsHiddenOnFakeCell
        
        commandsForAddingRoutes = [
            { router in
                MixboxInAppServices.registerDefaultMethods(router: router)
            }
        ]
    }
    
    public convenience init?(environment: [String: String] = ProcessInfo.processInfo.environment) {
        let ipcStarterOrNil: IpcStarter?
        let ipcStarterType = MixboxInAppServices.ipcStarterType(environment: environment)
        
        switch ipcStarterType {
        case .blackbox?:
            if let testRunnerHost = environment["MIXBOX_HOST"],
                let testRunnerPort = environment["MIXBOX_PORT"].flatMap({ UInt($0) })
            {
                ipcStarterOrNil = BuiltinIpcStarter(
                    testRunnerHost: testRunnerHost,
                    testRunnerPort: testRunnerPort
                )
            } else {
                ipcStarterOrNil = nil
            }
        case .sbtui?:
            ipcStarterOrNil = SbtuiIpcStarter(
                reregisterMethodHandlersAutomatically: environment["MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY"] == "true"
            )
        case .graybox?:
            ipcStarterOrNil = GrayBoxIpcStarter()
        case nil:
            ipcStarterOrNil = nil
        }
        
        guard let ipcStarter = ipcStarterOrNil else {
            assertionFailure("Failed to start IPC")
            return nil
        }
        
        self.init(
            ipcStarter: ipcStarter,
            shouldEnhanceAccessibilityValue: ipcStarterType != IpcStarterType.graybox, // FIXME
            shouldEnableFakeCells: (environment["MIXBOX_SHOULD_ENABLE_FAKE_CELLS"] ?? "true") == "true",
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
    
    public func start() -> (IpcRouter, IpcClient?) {
        assert(self.router == nil, "MixboxInAppServices are already started")
        
        do {
            let (client, router) = try ipcStarter.start(commandsForAddingRoutes: commandsForAddingRoutes)
            
            self.router = client
            self.client = router
            
            AccessibilityEnhancer.takeOff(
                shouldEnableFakeCells: shouldEnableFakeCells,
                shouldEnhanceAccessibilityValue: shouldEnhanceAccessibilityValue,
                shouldAddAssertionForCallingIsHiddenOnFakeCell: shouldAddAssertionForCallingIsHiddenOnFakeCell
            )
            
            return (client, router)
        } catch {
            // TODO: Better error handling for tests (fail test instead of crashing app)
            preconditionFailure(String(describing: error))
        }
    }
    
    private static func registerDefaultMethods(router: IpcRouter) {
        router.register(methodHandler: ScrollingHintIpcMethodHandler())
        router.register(methodHandler: PercentageOfVisibleAreaIpcMethodHandler())
        router.register(
            methodHandler: ViewHierarchyIpcMethodHandler(
                viewHierarchyProvider: ViewHierarchyProviderImpl()
            )
        )
        
        router.register(methodHandler: OpenUrlIpcMethodHandler())
        
        router.register(methodHandler: PushNotificationIpcMethodHandler())
        
        router.register(methodHandler: SimulateLocationIpcMethodHandler())
        router.register(methodHandler: StopLocationSimulationIpcMethodHandler())
        
        router.register(
            methodHandler: InjectKeyboardEventsIpcMethodHandler(
                keyboardEventInjector: KeyboardEventInjectorImpl(application: UIApplication.shared)
            )
        )
        
        router.register(methodHandler: GetPasteboardStringIpcMethodHandler())
        router.register(methodHandler: SetPasteboardStringIpcMethodHandler())
    }
    
    private static func ipcStarterType(environment: [String: String]) -> IpcStarterType? {
        if let typeString = environment["MIXBOX_IPC_STARTER_TYPE"], !typeString.isEmpty {
            guard let type = IpcStarterType(rawValue: typeString) else {
                assertionFailure("Unknown IpcStarterType: \(typeString) in MIXBOX_IPC_STARTER_TYPE environment variable")
                return nil
            }
            
            return type
        }
        
        // Fallback for earlier version. TODO: Remove on Oct 2019.
        
        if environment["MIXBOX_USE_BUILTIN_IPC"] == "true" {
            return .blackbox
        } else {
            return .sbtui
        }
    }
}

#endif
