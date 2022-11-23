#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import UIKit

public extension CGRect {
    func mb_shrinked(_ insets: UIEdgeInsets) -> CGRect {
        return inset(by: insets)
    }
    func mb_shrinked(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return mb_shrinked(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    func mb_extended(_ insets: UIEdgeInsets) -> CGRect {
        return mb_shrinked(insets.mb_inverted())
    }
    func mb_extended(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        return mb_shrinked(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right).mb_inverted())
    }
    
    // Return insets needed to shrink self to other.
    // A.mb_shrinked(A.mb_insetsToShrinkToRect(B)) == B
    func mb_insetsToShrinkToRect(_ other: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: other.mb_top - mb_top,
            left: other.mb_left - mb_left,
            bottom: mb_bottom - other.mb_bottom,
            right: mb_right - other.mb_right
        )
    }
}

#endif
