#if MIXBOX_ENABLE_IN_APP_SERVICES

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostActivityLoggerImpl: SignpostActivityLogger {
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
        name: StaticString,
        message: () -> (String?))
         -> SignpostActivity
    {
        let signpostLogger = signpostLoggerFactory.signpostLogger(
            subsystem: subsystem,
            category: category
        )
        
        let signpostId = signpostLogger.signpostId()
        
        signpostLogger.signpost(
            type: .begin,
            name: name,
            signpostId: signpostId,
            message: message()
        )
        
        return SignpostActivityImpl(
            signpostLogger: signpostLogger,
            signpostId: signpostId,
            name: name
        )
    }
}

#endif
