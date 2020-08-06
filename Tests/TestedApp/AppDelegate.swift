import UIKit
import MixboxInAppServices
import MixboxIpc
import MixboxIpcCommon
import TestsIpc

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    // These properties are accessed from tests:
    var ipcClient: IpcClient?
    var ipcRouter: IpcRouter?
    let keyboardEventInjector: KeyboardEventInjector?
    let inAppServices: InAppServices?
    
    override init() {
        let factoryOrNil = InAppServicesDependenciesFactoryImpl(
            environment: ProcessInfo.processInfo.environment,
            performanceLogger: Singletons.performanceLogger
        )
        
        if let factory = factoryOrNil {
            inAppServices = InAppServices(
                inAppServicesDependenciesFactory: factory
            )
            
            keyboardEventInjector = factory.keyboardEventInjector
        } else {
            inAppServices = nil
            keyboardEventInjector = nil
        }
        
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        
        let uiEventHistoryTracker = UiEventHistoryTracker()
        
        let window = TouchDrawingWindow(
            frame: UIScreen.main.bounds,
            uiEventObserver: uiEventHistoryTracker
        )
        
        self.window = window
        
        let rootViewControllerManager = RootViewControllerManagerImpl(
            window: window,
            defaultViewController: IntermediateBetweenTestsViewController()
        )
        
        #if DEBUG
        if ProcessInfo.processInfo.environment["MIXBOX_IPC_STARTER_TYPE"] != nil {
            if let inAppServices = inAppServices {
                let customIpcMethods = CustomIpcMethods(
                    uiEventHistoryProvider: uiEventHistoryTracker,
                    rootViewControllerManager: rootViewControllerManager
                )
                
                // TODO: add environment to be able to disable registration of methods?
                customIpcMethods.registerIn(inAppServices)
                
                let startedInAppServices = inAppServices.start()
                ipcRouter = startedInAppServices.router
                ipcClient = startedInAppServices.client
            }
        }
        #endif
        
        rootViewControllerManager.set(rootViewController: nil, completion: {})
        window.makeKeyAndVisible()
        
        return true
    }
}
