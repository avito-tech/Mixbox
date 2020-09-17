import UIKit
import TestsIpc
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

public final class KeyboardEventInjectorImplTestsView:
    UIView,
    TestingView,
    UITextViewDelegate
{
    private var textView = UITextView()
    
    public init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        testingViewControllerSettings.viewIpc.registerResetUiMethod(view: self) { view in
            view.resetUi()
        }
        
        resetUi()
    }
    
    private func resetUi() {
        textView.removeFromSuperview()
        backgroundColor = .white
        
        textView = UITextView()
        
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.accessibilityIdentifier = "textView"
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        
        textView.delegate = self
        
        addSubview(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewIsFocused(true)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        setTextViewIsFocused(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = bounds.mb_shrinked(top: 60, left: 10, bottom: 60, right: 10)
    }
    
    private func setTextViewIsFocused(_ isFocused: Bool) {
        textView.mb_testability_customValues["isFocused"] = isFocused
    }
}
