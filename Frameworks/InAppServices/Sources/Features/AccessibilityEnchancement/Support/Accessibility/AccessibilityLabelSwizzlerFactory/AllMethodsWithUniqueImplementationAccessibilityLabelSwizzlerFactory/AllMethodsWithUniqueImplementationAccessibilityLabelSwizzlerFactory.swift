#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// For testing init arguments of `AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler`.
// Testing of this swizzling is very important.
public protocol AllMethodsWithUniqueImplementationAccessibilityLabelSwizzlerFactory {
    func allMethodsWithUniqueImplementationAccessibilityLabelSwizzler(
        enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler,
        objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
        -> AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler
}

#endif
