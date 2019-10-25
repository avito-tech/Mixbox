import UIKit
import TestsIpc
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

public final class KeyboardEventInjectorImplTestsView:
    UIView,
    InitializableWithTestingViewControllerSettings,
    UITextViewDelegate
{
    private var textView = UITextView()
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        viewIpc.register(method: ResetUiIpcMethod()) { [weak self] _, completion in
            guard let strongSelf = self else {
                completion(IpcThrowingFunctionResult.threw(ErrorString("self is nil")))
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.resetUi()
                completion(IpcThrowingFunctionResult.returned(IpcVoid()))
            }
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
        textView.testability_customValues["isFocused"] = isFocused
    }
}
