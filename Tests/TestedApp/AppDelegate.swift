import UIKit
import MixboxInAppServices
import MixboxIpc
import MixboxIpcCommon

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    // These properties are accessed from tests:
    var ipcClient: IpcClient?
    var ipcRouter: IpcRouter?
    let keyboardEventInjector: KeyboardEventInjector?
    let mixboxInAppServices: MixboxInAppServices?
    
    override init() {
        let factoryOrNil = InAppServicesDependenciesFactoryImpl(
            environment: ProcessInfo.processInfo.environment
        )
        
        if let factory = factoryOrNil {
            mixboxInAppServices = MixboxInAppServices(
                inAppServicesDependenciesFactory: factory
            )
            
            keyboardEventInjector = factory.keyboardEventInjector
        } else {
            mixboxInAppServices = nil
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
            if let mixboxInAppServices = mixboxInAppServices {
                let customIpcMethods = CustomIpcMethods(
                    uiEventHistoryProvider: uiEventHistoryTracker,
                    rootViewControllerManager: rootViewControllerManager
                )
                
                // TODO: add environment to be able to disable registration of methods?
                customIpcMethods.registerIn(mixboxInAppServices)
                
                // Yes, Swift is stupid sometimes:
                let (router, client) = mixboxInAppServices.start()
                (ipcRouter, ipcClient) = (router, client)
            }
        }
        #endif
        
        rootViewControllerManager.set(rootViewController: nil, completion: {})
        window.makeKeyAndVisible()
        
        return true
    }
}
