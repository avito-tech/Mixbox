import UIKit

final class TestingViewControllerSettings {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

final class TestingViewController: UIViewController {
    private let testingViewControllerSettings: TestingViewControllerSettings
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        self.testingViewControllerSettings = testingViewControllerSettings
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let prefix = "\(ApplicationNameProvider.applicationName)." // TODO: get module name properly
        let className = testingViewControllerSettings.name
        
        if let metaclass = NSClassFromString(prefix + className) as? UIView.Type {
            view = metaclass.init()
        } else {
            view = UIView()
            view.backgroundColor = .white
        }
    }
}
