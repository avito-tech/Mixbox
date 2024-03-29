#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public final class AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactoryImpl:
    AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory
{
    public init() {
    }
    
    public func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
        enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler,
        objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
        -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler
    {
        return AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
            enhancedAccessibilityLabelMethodSwizzler: enhancedAccessibilityLabelMethodSwizzler,
            objcMethodsWithUniqueImplementationProvider: objcMethodsWithUniqueImplementationProvider,
            baseClass: baseClass,
            selector: selector,
            methodType: methodType
        )
    }
}

#endif
