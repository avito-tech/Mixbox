import UIKit
import MixboxInAppServices

public final class TestingViewFactory {
    public init() {
    }
    
    public func rootViewController(
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?)
        -> UIViewController
    {
         // TODO: get module name properly
        let moduleName = ApplicationNameProvider.applicationName
        let objcClassName = "\(moduleName).\(viewType)"
        
        if let viewClass = NSClassFromString(objcClassName) {
            let viewControllerContainerType: ViewControllerContainerType
            
            if let viewControllerContainerTypeProvider = viewClass as? ViewControllerContainerTypeProvider.Type {
                viewControllerContainerType = viewControllerContainerTypeProvider.viewControllerContainerType
            } else {
                viewControllerContainerType = .default
            }
            
            return rootViewController(
                viewClass: viewClass,
                viewType: viewType,
                mixboxInAppServices: mixboxInAppServices,
                viewControllerContainerType: viewControllerContainerType
            )
        } else {
            return fallbackViewController()
        }
    }
    
    private func fallbackViewController() -> UIViewController {
        return TestingViewController {
            Self.instantiateFallbackView()
        }
    }
    
    private func rootViewController(
        viewClass: AnyClass,
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?,
        viewControllerContainerType: ViewControllerContainerType)
        -> UIViewController
    {
        switch viewControllerContainerType {
        case .none:
            return testingViewController(
                viewClass: viewClass,
                viewType: viewType,
                mixboxInAppServices: mixboxInAppServices,
                navigationController: nil
            )
        case .navigationController:
            return navigationController(
                viewClass: viewClass,
                viewType: viewType,
                mixboxInAppServices: mixboxInAppServices
            )
        }
    }
    
    private func navigationController(
        viewClass: AnyClass,
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?)
        -> UIViewController
    {
        let navigationController = UINavigationController()
        
        let viewController = testingViewController(
            viewClass: viewClass,
            viewType: viewType,
            mixboxInAppServices: mixboxInAppServices,
            navigationController: navigationController
        )
        
        navigationController.setViewControllers([viewController], animated: false)
        
        return navigationController
    }
    
    private func testingViewController(
        viewClass: AnyClass,
        viewType: String,
        mixboxInAppServices: MixboxInAppServices?,
        navigationController: UINavigationController?)
        -> UIViewController
    {
        let testingViewControllerSettings = TestingViewControllerSettings(
            viewType: viewType,
            mixboxInAppServices: mixboxInAppServices,
            navigationController: navigationController
        )
        
        return TestingViewController {
            Self.makeView(
                viewClass: viewClass,
                testingViewControllerSettings: testingViewControllerSettings
            )
        }
    }
    
    private static func makeView(
        viewClass: AnyClass,
        testingViewControllerSettings: TestingViewControllerSettings)
        -> UIView
    {
        let viewToReturn: UIView
        
        if let view = instantiateAsViewInitializableWithTestingViewControllerSettings(viewClass, testingViewControllerSettings) {
            viewToReturn = view
        } else if let view = instantiateAsView(viewClass) {
            viewToReturn = view
        } else {
            viewToReturn = instantiateFallbackView()
        }
            
        viewToReturn.accessibilityIdentifier = testingViewControllerSettings.viewType
        
        return viewToReturn
    }
    
    private static func instantiateFallbackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    private static func instantiateAsView(_ anyClass: AnyClass) -> UIView? {
        guard let viewClass = anyClass as? UIView.Type else {
            return nil
        }
        
        return viewClass.init()
    }
    
    private static func instantiateAsViewInitializableWithTestingViewControllerSettings(
        _ anyClass: AnyClass,
        _ testingViewControllerSettings: TestingViewControllerSettings)
        -> UIView?
    {
        guard anyClass is UIView.Type else {
            return nil
        }
        
        guard let initializableWithTestingViewControllerSettingsClass = anyClass as? (InitializableWithTestingViewControllerSettings.Type) else {
            return nil
        }
        
        let initializableWithTestingViewControllerSettings = initializableWithTestingViewControllerSettingsClass.init(
            testingViewControllerSettings: testingViewControllerSettings
        )
        
        return initializableWithTestingViewControllerSettings as? UIView
    }
}
