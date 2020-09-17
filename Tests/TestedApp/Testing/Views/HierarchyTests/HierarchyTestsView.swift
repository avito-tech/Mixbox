import UIKit

// TODO: Better code in this test, see swiftlint:disable
//  swiftlint:disable function_body_length
final class HierarchyTestsView: UIView {
    init() {
        super.init(frame: CGRect(x: 10000, y: 10000, width: 10000, height: 10000))
        
        let label = UILabel(frame: .zero)
        label.accessibilityValue = "label.accessibilityValue"
        label.accessibilityLabel = "label.accessibilityLabel"
        label.accessibilityIdentifier = "label.accessibilityIdentifier"
        label.frame = CGRect(x: 0, y: 1, width: 100, height: 101)
        label.text = "label.text"
        label.isUserInteractionEnabled = false
        label.mb_testability_customValues["label.mb_testability_customValues"] = "label.mb_testability_customValues"
        addSubview(label)
        
        let hiddenLabel = UILabel(frame: .zero)
        hiddenLabel.accessibilityValue = "hiddenLabel.accessibilityValue"
        hiddenLabel.accessibilityLabel = "hiddenLabel.accessibilityLabel"
        hiddenLabel.accessibilityIdentifier = "hiddenLabel.accessibilityIdentifier"
        hiddenLabel.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        hiddenLabel.text = "hiddenLabel.text"
        hiddenLabel.isUserInteractionEnabled = true
        hiddenLabel.isHidden = true
        hiddenLabel.mb_testability_customValues["hiddenLabel.mb_testability_customValues"] = "hiddenLabel.mb_testability_customValues"
        addSubview(hiddenLabel)
        
        let button = CustomButton(frame: .zero)
        button.accessibilityValue = "button.accessibilityValue"
        button.accessibilityLabel = "button.accessibilityLabel"
        button.accessibilityIdentifier = "button.accessibilityIdentifier"
        button.frame = CGRect(x: -10000, y: 1, width: 100, height: 101)
        button.setTitle("button.text", for: .normal)
        button.isEnabled = false
        button.mb_testability_customValues["button.mb_testability_customValues"] = "button.mb_testability_customValues"
        addSubview(button)
        
        let hiddenButton = UIButton(frame: .zero)
        hiddenButton.accessibilityValue = "hiddenButton.accessibilityValue"
        hiddenButton.accessibilityLabel = "hiddenButton.accessibilityLabel"
        hiddenButton.accessibilityIdentifier = "hiddenButton.accessibilityIdentifier"
        hiddenButton.frame = CGRect(x: 10000, y: 10, width: 100, height: 101)
        hiddenButton.setTitle("hiddenButton.text", for: .normal)
        hiddenButton.alpha = 0
        hiddenButton.isEnabled = true
        hiddenButton.mb_testability_customValues["hiddenButton.mb_testability_customValues"] = "hiddenButton.mb_testability_customValues"
        addSubview(hiddenButton)
        
        let focusedTextField = UITextField(frame: .zero)
        focusedTextField.accessibilityValue = "focusedTextField.accessibilityValue"
        focusedTextField.accessibilityLabel = "focusedTextField.accessibilityLabel"
        focusedTextField.accessibilityIdentifier = "focusedTextField.accessibilityIdentifier"
        focusedTextField.frame = CGRect(x: 10000, y: 1, width: 100, height: 101)
        focusedTextField.placeholder = "focusedTextField.placeholder"
        focusedTextField.alpha = 0
        focusedTextField.mb_testability_customValues["focusedTextField.mb_testability_customValues"] = "focusedTextField.mb_testability_customValues"
        focusedTextField.isSecureTextEntry = true
        addSubview(focusedTextField)
        focusedTextField.becomeFirstResponder()
        
        let notFocusedTextView = UITextView(frame: .zero)
        notFocusedTextView.accessibilityValue = "notFocusedTextView.accessibilityValue"
        notFocusedTextView.accessibilityLabel = "notFocusedTextView.accessibilityLabel"
        notFocusedTextView.accessibilityIdentifier = "notFocusedTextView.accessibilityIdentifier"
        notFocusedTextView.frame = CGRect(x: 1000, y: 1, width: 100, height: 101)
        notFocusedTextView.text = "notFocusedTextView.text"
        notFocusedTextView.alpha = 0
        notFocusedTextView.mb_testability_customValues["notFocusedTextView.mb_testability_customValues"] = "notFocusedTextView.mb_testability_customValues"
        addSubview(notFocusedTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CustomButton: UIButton {}
