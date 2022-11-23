#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public enum GraphiteClientError: Error, CustomStringConvertible {
    case unableToGetData(from: String)
    case incorrectMetricPath(String)
    case incorrectValue(Double)
    
    public var description: String {
        switch self {
        case .unableToGetData(let from):
            return "Unable to convert string '\(from)' to data"
        case .incorrectMetricPath(let value):
            return "The provided metric path is incorrect: \(value)"
        case .incorrectValue(let value):
            return "The provided metric value is incorrect: \(value)"
        }
    }
}

#endif
