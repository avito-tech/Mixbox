#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostMeasureableTimedActivityLogger: MeasureableTimedActivityLogger {
    private let signpostLoggerFactory: SignpostLoggerFactory
    private let subsystem: String
    private let category: String
    
    public init(
        signpostLoggerFactory: SignpostLoggerFactory,
        subsystem: String,
        category: String)
    {
        self.signpostLoggerFactory = signpostLoggerFactory
        self.subsystem = subsystem
        self.category = category
    }
    
    public func start(
        staticName: StaticString,
        dynamicName: () -> (String?))
         -> MeasureableTimedActivity
    {
        let signpostLogger = signpostLoggerFactory.signpostLogger(
            subsystem: subsystem,
            category: category
        )
        
        let signpostId = signpostLogger.signpostId()
        
        signpostLogger.signpost(
            type: .begin,
            name: staticName,
            signpostId: signpostId,
            message: dynamicName()
        )
        
        return SignpostMeasureableTimedActivity(
            signpostLogger: signpostLogger,
            signpostId: signpostId,
            name: staticName
        )
    }
}

#endif
