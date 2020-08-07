import UIKit
import MixboxInAppServices
import MixboxIpc
import MixboxIpcCommon
import MixboxDi
import MixboxBuiltinDi
import TestsIpc

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    #if DEBUG
    
    // These properties are accessed from tests:
    
    let inAppServicesDependencyInjection = BuiltinDependencyInjection()
    let inAppServices: InAppServices
    var startedInAppServices: StartedInAppServices?
    
    #endif
    
    override init() {
        #if DEBUG
        
        inAppServices = InAppServices(
            dependencyInjection: inAppServicesDependencyInjection,
            dependencyCollectionRegisterer: InAppServicesDependencyCollectionRegisterer()
        )
        
        #endif
        
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
            let customIpcMethods = CustomIpcMethods(
                uiEventHistoryProvider: uiEventHistoryTracker,
                rootViewControllerManager: rootViewControllerManager
            )
            
            // TODO: add environment to be able to disable registration of methods?
            customIpcMethods.registerIn(inAppServices)
            
            startedInAppServices = inAppServices.start()
        }
        #endif
        
        rootViewControllerManager.set(rootViewController: nil, completion: {})
        window.makeKeyAndVisible()
        
        return true
    }
}
