#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
