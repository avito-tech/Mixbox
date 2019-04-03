import UIKit

final class TestingViewController: UIViewController {
    private let testingViewControllerSettings: TestingViewControllerSettings
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        self.testingViewControllerSettings = testingViewControllerSettings
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Display errors instead of fallback?
    override func loadView() {
        let prefix = "\(ApplicationNameProvider.applicationName)." // TODO: get module name properly
        let className = testingViewControllerSettings.name
        
        if let anyClass = NSClassFromString(prefix + className) {
            if let view = instantiateAsViewInitializableWithTestingViewControllerSettings(anyClass) {
                self.view = view
            } else if let view = instantiateAsView(anyClass) {
                self.view = view
            }
        }
        
        if view == nil {
            self.view = instantiateFallbackView()
        }
    }
    
    private func instantiateFallbackView() -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    private func instantiateAsView(_ anyClass: AnyClass) -> UIView? {
        guard let viewClass = anyClass as? UIView.Type else {
            return nil
        }
        
        return viewClass.init()
    }
    
    private func instantiateAsViewInitializableWithTestingViewControllerSettings(_ anyClass: AnyClass) -> UIView? {
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
