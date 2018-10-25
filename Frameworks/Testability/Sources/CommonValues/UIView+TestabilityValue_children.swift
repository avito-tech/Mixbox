#if TEST

import UIKit

extension UIView {
    @objc override open func testabilityValue_children() -> [UIView] {
        return subviews
    }
}

#endif
