#if MIXBOX_ENABLE_IN_APP_SERVICES

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
}

#endif
