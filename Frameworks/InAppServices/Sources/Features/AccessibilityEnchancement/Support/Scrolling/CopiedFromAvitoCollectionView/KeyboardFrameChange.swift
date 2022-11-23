#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

// Copypasted from other app. TODO: Share?
public struct KeyboardFrameChange {
    public var animationDuration: TimeInterval
    public var keyboardFrameBegin: CGRect
    public var keyboardFrameEnd: CGRect
    public var viewAnimationCurve: UIView.AnimationCurve
    
    // MARK: - Helpers
    static func animatedFrameChange(
        _ animationDuration: TimeInterval,
        keyboardFrameBegin: CGRect,
        keyboardFrameEnd: CGRect,
        viewAnimationCurve: UIView.AnimationCurve) -> KeyboardFrameChange {
        
        return KeyboardFrameChange(
            animationDuration: animationDuration,
            keyboardFrameBegin: keyboardFrameBegin,
            keyboardFrameEnd: keyboardFrameEnd,
            viewAnimationCurve: viewAnimationCurve
        )
    }
    
    static func staticFrameChange(_ keyboardFrame: CGRect) -> KeyboardFrameChange {
        return KeyboardFrameChange(
            animationDuration: 0,
            keyboardFrameBegin: keyboardFrame,
            keyboardFrameEnd: keyboardFrame,
            viewAnimationCurve: .linear
        )
    }
    
    public func animateChange(_ animations: () -> ()) {
        if animationDuration > 0 {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(animationDuration)
            UIView.setAnimationCurve(viewAnimationCurve)
            UIView.setAnimationBeginsFromCurrentState(false)
            
            animations()
            
            UIView.commitAnimations()
        } else {
            animations()
        }
    }
}

#endif
