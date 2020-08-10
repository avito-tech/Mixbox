import UIKit
import MixboxInAppServices
import MixboxIpc
import MixboxIpcCommon
import MixboxDi
import MixboxBuiltinDi
import TestsIpc

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UiEventObservingWindow?
    
    #if DEBUG
    
    // These properties are accessed from tests:
    
    let inAppServicesDependencyInjection = BuiltinDependencyInjection()
    let inAppServices: InAppServices
    var startedInAppServices: StartedInAppServices?
    
    #endif
    
    override init() {
        #if DEBUG
        
        inAppServices = InAppServicesImpl(
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
        let window = UiEventObservingWindow(
            frame: UIScreen.main.bounds
        )
        
        self.window = window
        
        let rootViewControllerManager = RootViewControllerManagerImpl(
            window: window,
            defaultViewController: IntermediateBetweenTestsViewController()
        )
        
        #if DEBUG
        if ProcessInfo.processInfo.environment["MIXBOX_IPC_STARTER_TYPE"] != nil {
            inAppServices.set(uiEventObservable: window)
            
            let customIpcMethods = CustomIpcMethods(
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
