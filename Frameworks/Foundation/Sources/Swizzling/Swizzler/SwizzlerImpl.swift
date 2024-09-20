#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

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
