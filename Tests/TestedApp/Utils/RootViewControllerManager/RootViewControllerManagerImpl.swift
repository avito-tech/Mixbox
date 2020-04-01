import UIKit

public final class RootViewControllerManagerImpl: RootViewControllerManager {
    private let window: UIWindow
    private let defaultViewController: UIViewController
    
    public init(
        window: UIWindow,
        defaultViewController: UIViewController)
    {
        self.window = window
        self.defaultViewController = defaultViewController
    }
    
    public func set(rootViewController: UIViewController?, completion: @escaping () -> ()) {
        let afterPresentedViewControllerIsDismissed = { [window, defaultViewController] in
            window.rootViewController = rootViewController ?? defaultViewController
            
            completion()
        }
        
        if let presenterViewController = window.rootViewController?.presentedViewController {
            presenterViewController.dismiss(animated: false, completion: afterPresentedViewControllerIsDismissed)
        } else {
            afterPresentedViewControllerIsDismissed()
        }
    }
}
