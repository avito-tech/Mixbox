#if MIXBOX_ENABLE_IN_APP_SERVICES

@available(iOS 12.0, OSX 10.14, *)
public protocol SignpostLoggerFactory {
    func signpostLogger(
        subsystem: String,
        category: String)
        -> SignpostLogger
}

#endif
