#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Duplicates the interface of MeasureableTimedActivityLogger, but adds ability
// to log into multiple systems at once.
//
// Signpost:
// `staticName` will be a name of a signpost event
// `dynamicName` will be a message of a signpost event
//
// Graphite:
// `dynamicName` will be name of a graphite metric if it is not nil, `staticName` will be used otherwise
//
// Instances should be thread safe.
//
public protocol PerformanceLogger: AnyObject {
    func startImpl(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?),
        destinations: Set<PerformanceLoggerDestination>)
        -> MeasureableTimedActivity
}

extension PerformanceLogger {
    @inline(__always)
    public func start(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?) = nilString,
        destinations: Set<PerformanceLoggerDestination> = PerformanceLoggerDestination.allDestinations)
        -> MeasureableTimedActivity
    {
        startImpl(
            staticName: staticName,
            dynamicName: dynamicName,
            destinations: destinations
        )
    }
    
    @inline(__always)
    public func log<T>(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?) = nilString,
        destinations: Set<PerformanceLoggerDestination> = PerformanceLoggerDestination.allDestinations,
        body: () throws -> T
    ) rethrows -> T {
        let activity = startImpl(
            staticName: staticName,
            dynamicName: dynamicName,
            destinations: destinations
        )
        
        defer {
            activity.stop()
        }
        
        return try body()
    }
    
    @inline(__always)
    public func logSignpost<T>(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?) = nilString,
        body: () throws -> T)
        rethrows
        -> T
    {
        try log(
            staticName: staticName,
            dynamicName: dynamicName,
            destinations: PerformanceLoggerDestination.signpostDestinations,
            body: body
        )
    }
    
    public static func nilString() -> String? {
        return nil
    }
}

#endif
