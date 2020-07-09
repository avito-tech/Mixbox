#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol MeasureableTimedActivityLogger: class {
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
        body: () -> T)
        -> T
    {
        let activity = start(staticName: staticName, dynamicName: dynamicName)
        
        let returnValue = body()
        
        activity.stop()
        
        return returnValue
    }
}

#endif
