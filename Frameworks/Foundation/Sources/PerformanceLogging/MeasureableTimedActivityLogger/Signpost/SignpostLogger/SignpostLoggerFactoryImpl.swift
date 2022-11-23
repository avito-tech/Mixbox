#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
