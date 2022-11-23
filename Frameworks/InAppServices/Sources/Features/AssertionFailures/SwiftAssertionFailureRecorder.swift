#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public final class StandardLibraryAssertionFailureRecorder: AssertionFailureRecorder {
    public init() {
    }
    
    public func recordAssertionFailure(
        message: String,
        fileLine: FileLine)
    {
        assertionFailure(message, file: fileLine.file, line: fileLine.line)
    }
}

#endif
