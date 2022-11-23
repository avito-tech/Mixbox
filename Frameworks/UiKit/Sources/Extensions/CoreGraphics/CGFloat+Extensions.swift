#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

import CoreGraphics

extension CGFloat {
    public func mb_ceil() -> CGFloat {
        return CoreGraphics.ceil(self)
    }
    
    public func mb_floor() -> CGFloat {
        return CoreGraphics.floor(self)
    }
}

#endif
