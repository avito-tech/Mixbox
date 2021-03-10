#if MIXBOX_ENABLE_IN_APP_SERVICES

import os

@available(iOS 12.0, OSX 10.14, *)
public protocol SignpostLogger {
    func signpostId() -> OSSignpostID
    
    func signpost(
        type: OSSignpostType,
        name: StaticString,
        signpostId: OSSignpostID,
        message: String?)
}

#endif
