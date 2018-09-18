public final class SwizzlerImpl: Swizzler {
    public init() {
    }
    
    public func swizzle(
        _ class: NSObject.Type,
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
        
        guard let originalMethod = methodGetter(`class`, originalSelector) else {
            return .failedToGetOriginalMethod(`class`, originalSelector)
        }
        guard let swizzledMethod = methodGetter(`class`, swizzledSelector) else {
            return .failedToGetSwizzledMethod(`class`, swizzledSelector)
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        
        return .swizzledOriginalMethod(originalMethod)
    }
}
