#if MIXBOX_ENABLE_IN_APP_SERVICES

import os

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostActivityImpl: SignpostActivity {
    private let signpostLogger: SignpostLogger
    private let signpostId: OSSignpostID
    private let name: StaticString
    
    public init(
        signpostLogger: SignpostLogger,
        signpostId: OSSignpostID,
        name: StaticString)
    {
        self.signpostLogger = signpostLogger
        self.signpostId = signpostId
        self.name = name
    }
    
    public func stop() {
        signpostLogger.signpost(
            type: .end,
            name: name,
            signpostId: signpostId,
            message: nil
        )
    }
}

#endif
