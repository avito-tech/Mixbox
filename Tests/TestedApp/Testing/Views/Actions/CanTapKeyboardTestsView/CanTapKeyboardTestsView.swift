import UIKit
import MixboxTestability
import TestsIpc

final class CanTapKeyboardTestsView: UIView, UITextFieldDelegate, TestingView {
    private let textField = UITextField()
    private let statusLabel = UILabel()
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        addSubview(textField)
        
        addSubview(statusLabel)
        
        testingViewControllerSettings.viewIpc.registerResetUiMethod(view: self, argumentType: CanTapKeyboardTestsViewConfiguration.self) { view, configuration in
            view.resetUi(configuration: configuration)
        }
        
        resetUi(
            configuration: CanTapKeyboardTestsViewConfiguration(
                returnKeyType: .default
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetUi(configuration: CanTapKeyboardTestsViewConfiguration) {
        backgroundColor = .white
        
        textField.backgroundColor = .blue
        textField.delegate = self
        textField.accessibilityIdentifier = "textField"
        textField.returnKeyType = configuration.returnKeyType
        
        statusLabel.backgroundColor = .red
        statusLabel.text = "Initial"
        statusLabel.textAlignment = .center
        statusLabel.accessibilityIdentifier = "statusLabel"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = CGSize(
            width: bounds.width,
            height: 60
        )
        
        textField.mb_size = viewSize
        textField.mb_bottom = bounds.mb_centerY
        
        statusLabel.mb_size = viewSize
        statusLabel.mb_top = bounds.mb_centerY
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        statusLabel.text = "Resigned"
        textField.resignFirstResponder()
        return true
    }
}
