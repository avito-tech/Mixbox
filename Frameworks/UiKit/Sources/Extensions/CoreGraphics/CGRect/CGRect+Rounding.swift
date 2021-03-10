#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public extension CGRect {
    // Largest rectangle contained in self (size <= self)
    func mb_integralInside() -> CGRect {
        return CGRect.mb_init(
            left: mb_left.mb_ceil(),
            right: mb_right.mb_floor(),
            top: mb_top.mb_ceil(),
            bottom: mb_bottom.mb_floor()
        )
    }
    
    // Smallest rectangle containing self (size >= self)
    func mb_integralOutside() -> CGRect {
        return integral
    }
}

#endif
