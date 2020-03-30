import UIKit

public protocol RootViewControllerManager {
    // Pass `nil` to reset view controller to a default view controller
    func setRootViewController(_ rootViewController: UIViewController?)
}
