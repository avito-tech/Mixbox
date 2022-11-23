#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

extension UIAccessibilityElement {
    @objc override open func mb_testability_frame() -> CGRect {
        if #available(iOS 10.0, *) {
            return accessibilityFrameInContainerSpace
        } else {
            // TODO (non-view elements): Try to calculate based on `accessibilityFrame` and parents?
            return .null
        }
    }
}

#endif
