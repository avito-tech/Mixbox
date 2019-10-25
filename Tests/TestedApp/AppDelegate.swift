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
        
        window = TouchDrawingWindow(
            frame: UIScreen.main.bounds,
            uiEventObserver: uiEventHistoryTracker
        )
        
        let viewController: UIViewController
        
        if let screenNameForUiTests = ProcessInfo.processInfo.environment["MB_TESTS_screenName"] {
            viewController = TestingViewController(
                testingViewControllerSettings: TestingViewControllerSettings(
                    name: screenNameForUiTests,
                    mixboxInAppServices: mixboxInAppServices
                )
            )
        } else {
            viewController = UIViewController()
            viewController.view.backgroundColor = .white
        }
        
        #if DEBUG
        if ProcessInfo.processInfo.environment["MIXBOX_IPC_STARTER_TYPE"] != nil {
            if let mixboxInAppServices = mixboxInAppServices {
                let customIpcMethods = CustomIpcMethods(
                    uiEventHistoryProvider: uiEventHistoryTracker
                )
                
                // TODO: add environment to be able to disable registration of methods?
                customIpcMethods.registerIn(mixboxInAppServices)
                
                // Yes, Swift is stupid sometimes:
                let (router, client) = mixboxInAppServices.start()
                (ipcRouter, ipcClient) = (router, client)
            }
        }
        #endif
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
