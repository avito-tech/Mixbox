#if MIXBOX_ENABLE_IN_APP_SERVICES

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
