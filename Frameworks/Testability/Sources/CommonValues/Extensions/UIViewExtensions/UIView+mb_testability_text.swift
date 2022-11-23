#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

extension UILabel {
    @objc override open func mb_testability_text() -> String? {
        return text ?? ""
    }
}

extension UITextView {
    @objc override open func mb_testability_text() -> String? {
        return text ?? ""
    }
}

extension UITextField {
    @objc override open func mb_testability_text() -> String? {
        if let text = text, !text.isEmpty {
            return text
        } else {
            return placeholder
        }
    }
}

extension UIButton {
   @objc override open func mb_testability_text() -> String? {
        guard let label = titleLabel else {
            return ""
        }
        
        if label.isHidden == true || label.alpha == 0 {
            return ""
        }
        
        return label.mb_testability_text()
    }
}

#endif
