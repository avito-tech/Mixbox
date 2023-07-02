import UIKit
import MixboxTestability
import TestsIpc

final class SoftwareKeyboardTestsView: UIView, UITextFieldDelegate, TestingView {
    private let textField = UITextField()
    private let statusLabel = UILabel()
    private let viewThatCanBeHiddenBelowKeyboard = UILabel()
    private var configuration = SoftwareKeyboardTestsViewConfiguration.default()
    private var keyboardHeight: CGFloat = 0
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        addSubview(textField)
        addSubview(statusLabel)
        addSubview(viewThatCanBeHiddenBelowKeyboard)
        
        testingViewControllerSettings.viewIpc.registerResetUiMethod(
            view: self,
            argumentType: SoftwareKeyboardTestsViewConfiguration.self
        ) { view, configuration in
            self.configuration = configuration
            
            view.resetUi()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        resetUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetUi() {
        backgroundColor = .white
        
        textField.backgroundColor = .blue
        textField.delegate = self
        textField.accessibilityIdentifier = "textField"
        textField.returnKeyType = configuration.returnKeyType
        textField.inputAccessoryView = makeAccessoryView()
        
        statusLabel.backgroundColor = .red
        statusLabel.text = "Initial"
        statusLabel.textAlignment = .center
        statusLabel.accessibilityIdentifier = "statusLabel"
        
        viewThatCanBeHiddenBelowKeyboard.accessibilityIdentifier = "viewThatCanBeHiddenBelowKeyboard"
        viewThatCanBeHiddenBelowKeyboard.backgroundColor = .green
        viewThatCanBeHiddenBelowKeyboard.text = "View that can be hidden below keyboard"
        viewThatCanBeHiddenBelowKeyboard.textAlignment = .center
        
        setNeedsLayout()
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
        
        switch configuration.viewThatCanBeHiddenBelowKeyboard {
        case .hidden:
            viewThatCanBeHiddenBelowKeyboard.isHidden = true
        case .visibleWithHeight(let height):
            viewThatCanBeHiddenBelowKeyboard.isHidden = false
            viewThatCanBeHiddenBelowKeyboard.mb_height = height
        case .visibleWithHeightOfKeyboardIfKeyboardIsVisibleOrDefaultHeight(let defaultHeight):
            viewThatCanBeHiddenBelowKeyboard.isHidden = false
            
            if keyboardHeight > 0 {
                viewThatCanBeHiddenBelowKeyboard.mb_height = keyboardHeight
            } else {
                viewThatCanBeHiddenBelowKeyboard.mb_height = defaultHeight
            }
        }
        
        viewThatCanBeHiddenBelowKeyboard.mb_width = viewSize.width
        viewThatCanBeHiddenBelowKeyboard.mb_bottom = bounds.mb_bottom
    }
    
    private func makeAccessoryView() -> UIView? {
        switch configuration.keyboardAccessoryView {
        case .none:
            return nil
        case let .hideKeyboardButton(id, text):
            let button = TapIndicatorButton { [weak self] in
                self?.hideKeyboard()
            }
            
            button.setTitle(text, for: .normal)
            button.accessibilityIdentifier = id
            button.mb_height = 60
            
            return button
        }
    }
    
    private func hideKeyboard() {
        statusLabel.text = "Resigned"
        textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    // MARK: - NotificationCenter
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            keyboardHeight = 0
            setNeedsLayout()
            return
        }
        
        if let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = max(0, convert(bounds, to: nil).mb_bottom - keyboardFrame.cgRectValue.mb_top)
        } else {
            keyboardHeight = 0
        }
        
        setNeedsLayout()
        
        if let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let keyboardAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        {
            UIView.animate(
                withDuration: keyboardAnimationDuration,
                delay: 0,
                options: UIView.AnimationOptions(rawValue: UInt(keyboardAnimationCurve << 16))
            ) {
                self.layoutIfNeeded()
            }
        }
    }
}
