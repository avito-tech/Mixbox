#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public final class MachCurrentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider {
    public init() {
    }
    
    public func currentAbsoluteTime() -> AbsoluteTime {
        return AbsoluteTime(
            machAbsoluteTime: mach_absolute_time()
        )
    }
}

#endif
