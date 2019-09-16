#if MIXBOX_ENABLE_IN_APP_SERVICES

// To disable logging via DI
public final class DisabledSignpostActivityLogger: SignpostActivityLogger {
    public init() {
    }
    
    public func start(
        name: StaticString,
        message: () -> (String?))
        -> SignpostActivity
    {
        // Do nothing, logging is disabled
        
        return DisabledSignpostActivity()
    }
}

#endif
