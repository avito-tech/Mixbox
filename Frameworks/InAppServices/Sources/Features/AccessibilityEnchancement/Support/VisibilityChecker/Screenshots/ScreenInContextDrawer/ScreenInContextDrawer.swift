#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import CoreGraphics

public protocol ScreenInContextDrawer {
    func screenScale() -> CGFloat
    func screenBounds() -> CGRect
    
    func drawScreen(
        context: CGContext,
        afterScreenUpdates: Bool
    ) throws
}

#endif
