#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

// May be used to assert if there were no conflicts in swizzling
// And if swizzling was successful
public enum SwizzlingResult {
    case swizzledOriginalMethod(Method)
    case failedToGetOriginalMethod(NSObject.Type, Selector)
    case failedToGetSwizzledMethod(NSObject.Type, Selector)
    
    public var originalMethod: Method? {
        switch self {
        case .swizzledOriginalMethod(let method):
            return method
        default:
            return nil
        }
    }
    
    public var isSuccessful: Bool {
        switch self {
        case .swizzledOriginalMethod:
            return true
        case .failedToGetOriginalMethod:
            return false
        case .failedToGetSwizzledMethod:
            return false
        }
    }
}

#endif
