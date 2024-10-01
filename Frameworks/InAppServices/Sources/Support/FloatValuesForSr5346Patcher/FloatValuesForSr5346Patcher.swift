#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import CoreGraphics

public protocol FloatValuesForSr5346Patcher {
    func patched(float: CGFloat) -> CGFloat
}

extension FloatValuesForSr5346Patcher {
    public func patched(frame: CGRect) -> CGRect {
        return CGRect(
            x: patched(float: frame.origin.x),
            y: patched(float: frame.origin.y),
            width: patched(float: frame.size.width),
            height: patched(float: frame.size.height)
        )
    }
}

#endif
