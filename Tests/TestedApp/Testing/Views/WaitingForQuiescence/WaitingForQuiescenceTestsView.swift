import TestsIpc
import MixboxUiKit
import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

// This view contains scroll with high inertia and a very small button.
// This view is used to check that even if UI is moving, actions will wait until it becomes stable.
// High inertia of scroll view and small size of button increases chances of failing a test if there is an issue with waiting.
public final class WaitingForQuiescenceTestsView:
    UIView,
    InitializableWithTestingViewControllerSettings
{
    private var button = ButtonWithClosures()
    private var scrollView = UIScrollView()
    private var buttonOffsetFromScrollViewBounds: CGFloat = 500
    private let buttonOffsetFromContentTop: CGFloat = 500
    private let buttonHeight: CGFloat = 1 // it is harder to tap smaller button
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        let viewIpc = testingViewControllerSettings.viewIpc
        
        // TODO: This code is copypasted everywhere. Reuse it.
        viewIpc.register(method: ResetUiIpcMethod<CGFloat>()) { [weak self] buttonOffset, completion in
            guard let strongSelf = self else {
                completion(IpcThrowingFunctionResult.threw(ErrorString("self is nil")))
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.resetUi(buttonOffset: buttonOffset)
                completion(IpcThrowingFunctionResult.returned(IpcVoid()))
            }
        }
        
        resetUi(buttonOffset: buttonOffsetFromScrollViewBounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        scrollView.contentSize = bounds.size
            .mb_plusHeight(buttonOffsetFromScrollViewBounds + buttonOffsetFromContentTop)
        
        button.frame = CGRect(
            x: 0,
            y: scrollView.contentSize.height - buttonOffsetFromContentTop - buttonHeight,
            width: scrollView.contentSize.width,
            height: buttonHeight
        )
        
        button.accessibilityIdentifier = "button"
    }
    
    private func resetUi(buttonOffset: CGFloat) {
        button.removeFromSuperview()
        scrollView.removeFromSuperview()
        
        backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.decelerationRate = .init(rawValue: 0.9999) // less deceleration than `.normal` (0.998)
        
        button = ButtonWithClosures()
        button.backgroundColor = .blue
        button.testability_customValues["tapped"] = false
        button.onTap = { [weak self] in
            self?.button.testability_customValues["tapped"] = true
        }
        buttonOffsetFromScrollViewBounds = buttonOffset
        
        addSubview(scrollView)
        scrollView.addSubview(button)
    }
}
