#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol SignpostActivityLogger: class {
    func start(
        name: StaticString,
        message: () -> (String?))
        -> SignpostActivity
}

extension SignpostActivityLogger {
    @inline(__always)
    public func start(
        name: StaticString)
        -> SignpostActivity
    {
        return start(
            name: name,
            message: { nil }
        )
    }
    
    @inline(__always)
    public func log<T>(
        name: StaticString,
        message: () -> (String?) = { nil },
        body: () -> T)
        -> T
    {
        let activity = start(name: name, message: message)
        
        let returnValue = body()
        
        activity.stop()
        
        return returnValue
    }
}

#endif
