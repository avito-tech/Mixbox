#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

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
