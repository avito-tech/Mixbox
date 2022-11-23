#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import os

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostMeasureableTimedActivity: MeasureableTimedActivity {
    private let signpostLogger: SignpostLogger
    private let signpostId: OSSignpostID
    private let name: StaticString
    
    public init(
        signpostLogger: SignpostLogger,
        signpostId: OSSignpostID,
        name: StaticString)
    {
        self.signpostLogger = signpostLogger
        self.signpostId = signpostId
        self.name = name
    }
    
    public func stop() {
        signpostLogger.signpost(
            type: .end,
            name: name,
            signpostId: signpostId,
            message: nil
        )
    }
}

#endif
