#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

// Copypasted from other app. TODO: Share?

/// Adds and observer and stores it using a `weak` reference, so there is no need for a `removeObserver(_:)` method.
/// If an object calls the `addObserver` method twice, the completion blocks will be overwritten in favor of newer ones,
/// but the object will not be added to the observers list more than once
public protocol KeyboardFrameProvider: AnyObject {
    func addObserver(
        object: AnyObject,
        onKeyboardFrameWillChange: ((_ change: KeyboardFrameChange) -> ())?,
        onKeyboardFrameDidChange: ((_ endFrame: CGRect) -> ())?,
        onKeyboardWillShow: ((_ change: KeyboardFrameChange) -> ())?,
        onKeyboardWillHide: ((_ endFrame: CGRect) -> ())?
    )
    
    /// Returns intersection of keyboard frame and view
    func keyboardFrameInView(_ view: UIView) -> CGRect
    func nextKeyboardFrameInView(_ view: UIView) -> CGRect
}

#endif
