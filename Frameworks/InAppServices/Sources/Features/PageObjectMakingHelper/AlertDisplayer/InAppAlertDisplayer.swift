#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxFoundation
import UIKit

// TODO: Conform to `AlertDisplayer`, make `SynchronousAlertDisplayer`
public final class InAppAlertDisplayer {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    
    init(applicationWindowsProvider: ApplicationWindowsProvider) {
        self.applicationWindowsProvider = applicationWindowsProvider
    }
    
    public func display(
        alert: Alert,
        completion: @escaping () -> ())
        throws
    {
        let alertController = getAlertController(alert: alert, completion: completion)
        
        let rootViewController = try getRootViewController()
        
        rootViewController.present(alertController, animated: true, completion: nil)
    }
    
    private func getRootViewController() throws -> UIViewController {
        let window = try getWindow()
        
        var rootViewControllerOrNil = window.rootViewController
        
        if let navigationController = rootViewControllerOrNil as? UINavigationController {
            rootViewControllerOrNil = navigationController.viewControllers.first ?? rootViewControllerOrNil
        } else if let tabBarController = rootViewControllerOrNil as? UITabBarController {
            rootViewControllerOrNil = tabBarController.selectedViewController ?? rootViewControllerOrNil
        }
        
        if let rootViewController = rootViewControllerOrNil {
            return rootViewController
        } else {
            throw ErrorString("Failed to get root view controller")
        }
    }
    
    private func getAlertController(
        alert: Alert,
        completion: @escaping () -> ())
        -> UIAlertController
    {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.description,
            preferredStyle: .alert
        )
    
        let alert = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                completion()
            }
        )
        
        alertController.addAction(alert)
        
        return alertController
    }
    
    private func getWindow() throws -> UIWindow {
        guard let window = applicationWindowsProvider.keyWindow else {
            throw ErrorString(
                "applicationWindowsProvider.keyWindow is nil"
            )
        }
        
        return window
    }
}

#endif
