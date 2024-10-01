#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation

// TODO: Use everywhere
extension Selector {
    // Suppresses `Use '#selector' instead of explicitly constructing a 'Selector'` warning
    public static func mb_init(privateName: String) -> Selector {
        Selector(privateName)
    }
}

#endif
