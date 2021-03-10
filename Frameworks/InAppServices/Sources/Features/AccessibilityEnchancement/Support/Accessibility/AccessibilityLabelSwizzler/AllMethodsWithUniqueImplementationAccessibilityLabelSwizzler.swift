#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxTestability
import MixboxFoundation

public final class AllMethodsWithUniqueImplementationAccessibilityLabelSwizzler: AccessibilityLabelSwizzler {
    private let enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler
    private let objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider
    private let baseClass: NSObject.Type
    private let selector: Selector
    private let methodType: MethodType
    
    public init(
        enhancedAccessibilityLabelMethodSwizzler: EnhancedAccessibilityLabelMethodSwizzler,
        objcMethodsWithUniqueImplementationProvider: ObjcMethodsWithUniqueImplementationProvider,
        baseClass: NSObject.Type,
        selector: Selector,
        methodType: MethodType)
    {
        self.enhancedAccessibilityLabelMethodSwizzler = enhancedAccessibilityLabelMethodSwizzler
        self.objcMethodsWithUniqueImplementationProvider = objcMethodsWithUniqueImplementationProvider
        self.baseClass = baseClass
        self.selector = selector
        self.methodType = methodType
    }
    
    public func swizzle() {
        let accessibilityLabelMethods = objcMethodsWithUniqueImplementationProvider.objcMethodsWithUniqueImplementation(
            baseClass: baseClass,
            selector: selector,
            methodType: methodType
        )
        
        for method in accessibilityLabelMethods {
            enhancedAccessibilityLabelMethodSwizzler.swizzleAccessibilityLabelMethod(
                method: method.method
            )
        }
    }
}

#endif
