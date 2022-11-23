#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public enum EasyOutputStreamError: Error, CustomStringConvertible {
    case streamClosed
    case streamError(Error)
    case streamHasNoSpaceAvailable
    
    public var description: String {
        switch self {
        case .streamError(let error):
            return "Stream error: \(error)"
        case .streamClosed:
            return "Can't send data because stream is closed or about to close."
        case .streamHasNoSpaceAvailable:
            return "Stream has no space available"
        }
    }
}

#endif
