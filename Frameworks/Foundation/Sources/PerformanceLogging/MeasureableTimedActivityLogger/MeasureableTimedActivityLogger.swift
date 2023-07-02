#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public protocol MeasureableTimedActivityLogger: AnyObject {
    func start(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?))
        -> MeasureableTimedActivity
}

extension MeasureableTimedActivityLogger {
    @inline(__always)
    public func start(
        staticName: StaticString)
        -> MeasureableTimedActivity
    {
        return start(
            staticName: staticName,
            dynamicName: { nil }
        )
    }
    
    @inline(__always)
    public func log<T>(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?) = { nil },
        body: () throws -> T)
        rethrows
        -> T
    {
        let activity = start(staticName: staticName, dynamicName: dynamicName)
        
        defer {
            activity.stop()
        }
        
        return try body()
    }
}

#endif
