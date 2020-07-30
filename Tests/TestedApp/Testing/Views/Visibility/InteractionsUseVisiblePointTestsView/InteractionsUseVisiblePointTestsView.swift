import UIKit
import MixboxUiKit
import TestsIpc

final class InteractionsUseVisiblePointTestsView: UIView, TestingView {
    private var button = TapIndicatorButton()
    private var overlappingView = UIView()
    private var configuration = InteractionsUseVisiblePointTestsViewConfiguration(
        buttonFrame: .zero,
        overlappingViewFrame: .zero
    )
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerAsyncResetUiMethod(view: self, argumentType: InteractionsUseVisiblePointTestsViewConfiguration.self) { view, configuration, completion in
            view.resetUi(configuration: configuration, completion: completion)
        }
        
        resetUi(configuration: configuration, completion: {})
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = configuration.buttonFrame
        overlappingView.frame = configuration.overlappingViewFrame
    }
    
    private func resetUi(configuration: InteractionsUseVisiblePointTestsViewConfiguration, completion: @escaping () -> ()) {
        button.removeFromSuperview()
        overlappingView.removeFromSuperview()
        
        button = TapIndicatorButton()
        overlappingView = UIView()
        
        self.configuration = configuration
        
        backgroundColor = .white
        
        button.accessibilityIdentifier = "button"
        addSubview(button)
        
        overlappingView.backgroundColor = .gray
        addSubview(overlappingView)
        
        completion()
    }
}
