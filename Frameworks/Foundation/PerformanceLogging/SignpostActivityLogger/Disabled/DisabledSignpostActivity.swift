#if MIXBOX_ENABLE_IN_APP_SERVICES

// To disable logging via DI, see DisabledSignpostActivityLogger
public final class DisabledSignpostActivity: SignpostActivity {
    public init() {
    }
    
    public func stop() {
        // Do nothing, logging is disabled
    }
}

#endif
