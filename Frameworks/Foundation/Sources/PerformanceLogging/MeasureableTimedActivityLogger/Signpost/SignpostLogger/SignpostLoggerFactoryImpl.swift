#if MIXBOX_ENABLE_IN_APP_SERVICES

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostLoggerFactoryImpl: SignpostLoggerFactory {
    public init() {
    }
    
    public func signpostLogger(
        subsystem: String,
        category: String)
        -> SignpostLogger
    {
        return SignpostLoggerImpl(
            subsystem: subsystem,
            category: category
        )
    }
}

#endif
