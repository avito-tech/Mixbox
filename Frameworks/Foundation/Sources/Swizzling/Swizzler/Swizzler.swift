#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol Swizzler: AnyObject {
    func swizzle(
        _ originalClass: NSObject.Type,
        _ swizzlingClass: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
        -> SwizzlingResult
}

extension Swizzler {
    
    func swizzle(
        _ originalClass: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
        -> SwizzlingResult
    {
        self.swizzle(
            originalClass,
            originalClass,
            originalSelector,
            swizzledSelector,
            methodType
        )
    }
    
}

#endif
