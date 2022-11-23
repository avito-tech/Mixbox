#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import UIKit

public extension CGRect {
    func mb_pointToPixel(scale: CGFloat) -> CGRect {
        return mb_scaleAndTranslate(amount: scale)
    }

    func mb_pixelToPoint(scale: CGFloat) -> CGRect {
        return mb_scaleAndTranslate(amount: 1 / scale)
    }
}

#endif
