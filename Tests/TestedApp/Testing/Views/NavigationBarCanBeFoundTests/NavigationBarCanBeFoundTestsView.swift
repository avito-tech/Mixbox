import UIKit
import MixboxUiKit
import TestsIpc

final class NavigationBarCanBeFoundTestsView: UIView, TestingView {
    static var viewControllerContainerType: ViewControllerContainerType {
        return .navigationController
    }
    
    private let debugLabel = UILabel() // Just for visually identifying current test settings
    private var configuration: NavigationBarCanBeFoundTestsViewConfiguration?
    private weak var navigationController: UINavigationController?
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerAsyncResetUiMethod(view: self, argumentType: NavigationBarCanBeFoundTestsViewConfiguration.self) { view, configuration, completion in
            view.resetUi(configuration: configuration, completion: completion)
        }
        
        navigationController = testingViewControllerSettings.navigationController
        
        resetUi(configuration: configuration, completion: {})
        
        backgroundColor = .white
        debugLabel.numberOfLines = 0
        
        addSubview(debugLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        debugLabel.frame = bounds
    }
    
    private func resetUi(configuration: NavigationBarCanBeFoundTestsViewConfiguration?, completion: @escaping () -> ()) {
        resignFirstResponder()
        
        dismissEverything { [weak self] in
            guard let strongSelf = self else {
                completion()
                return
            }
            
            strongSelf.resetView(configuration: configuration) {
                completion()
            }
        }
    }
    
    private func resetView(configuration: NavigationBarCanBeFoundTestsViewConfiguration?, completion: @escaping () -> ()) {
        debugLabel.text = "View is not configured via IPC (this is not expected to persist)"
        
        self.configuration = configuration
        
        if let configuration = configuration {
            debugLabel.text =
            """
            This is a root view.

            At the beginning of test a view controller is expected to be pushed on top of it.
            
            If everything goes fine, the button on nested view controller is tapped and \
            you will see this view controller after button is tapped.

            View configuration:

            \(valueCodeGenerator.generateCode(
                value: configuration,
                typeCanBeInferredFromContext: false
            ))
            """
            
            navigationController?.pushViewController(
                NestedViewController(configuration: configuration),
                animated: false
            )
        }
        
        completion()
    }
    
    private func dismissEverything(completion: @escaping () -> ()) {
        navigationController?.popToRootViewController(animated: false)

        if let presentedViewController = navigationController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: completion)
        } else {
            completion()
        }
    }
}
