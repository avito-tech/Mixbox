#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class SwizzlerImpl: Swizzler {
    public init() {
    }
    
    public func swizzle(
        _ originalClass: NSObject.Type,
        _ swizzlingClass: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
        -> SwizzlingResult
    {
        let methodGetter: (NSObject.Type?, Selector) -> Method?
        
        switch methodType {
        case .instanceMethod:
            methodGetter = class_getInstanceMethod
        case .classMethod:
            methodGetter = class_getClassMethod
        }
        
        guard let originalMethod = methodGetter(originalClass, originalSelector) else {
            return .failedToGetOriginalMethod(originalClass, originalSelector)
        }
        guard let swizzledMethod = methodGetter(swizzlingClass, swizzledSelector) else {
            return .failedToGetSwizzledMethod(swizzlingClass, swizzledSelector)
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        
        return .swizzledOriginalMethod(originalMethod)
    }
    
}

#endif
