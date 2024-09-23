#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation
import MixboxFoundationObjc

public final class ObjectiveCExceptionCatcher {
    public static func `catch`<T>(
        try: () -> (T),
        catch: (NSException) -> (T),
        finally: () -> () = {})
        -> T
    {
        var result: T?

        ObjectiveCExceptionCatcherHelper_try(
            {
                result = `try`()
            },
            { e in
                result = `catch`(e)
            },
            finally
        )
        
        // swiftlint:disable:next force_unwrapping
        return result!
    }
    
    private init() {
    }
}

#endif
