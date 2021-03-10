#if MIXBOX_ENABLE_IN_APP_SERVICES

import os

@available(iOS 12.0, OSX 10.14, *)
public final class SignpostLoggerImpl: SignpostLogger {
    private let log: OSLog
    
    public init(
        subsystem: String,
        category: String)
    {
        log = OSLog(
            subsystem: subsystem,
            category: category
        )
    }
    
    public func signpostId()
        -> OSSignpostID
    {
        return OSSignpostID(
            log: log,
            object: NSObject()
        )
    }
    
    public func signpost(
        type: OSSignpostType,
        name: StaticString,
        signpostId: OSSignpostID,
        message: String?)
    {
        if let message = message {
            os_signpost(
                type,
                dso: #dsohandle,
                log: log,
                name: name,
                signpostID: signpostId,
                // https://developer.apple.com/documentation/os/logging
                // The unified logging system considers dynamic strings and complex dynamic
                // objects to be private, and does not collect them automatically. To ensure
                // the privacy of users, it is recommended that log messages consist strictly
                // of static strings and numbers. In situations where it is necessary to capture
                // a dynamic string, you may explicitly declare the string public using the
                // keyword public. For example, %{public}s.
                "%{public}s",
                message
            )
        } else {
            os_signpost(
                type,
                dso: #dsohandle,
                log: log,
                name: name,
                signpostID: signpostId
            )
        }
    }
}

#endif
