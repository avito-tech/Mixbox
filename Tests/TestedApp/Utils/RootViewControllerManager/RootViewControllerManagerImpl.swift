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
    
    public func setRootViewController(_ viewController: UIViewController?) {
        window.rootViewController = viewController ?? defaultViewController
    }
}
