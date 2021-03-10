#if MIXBOX_ENABLE_IN_APP_SERVICES

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
