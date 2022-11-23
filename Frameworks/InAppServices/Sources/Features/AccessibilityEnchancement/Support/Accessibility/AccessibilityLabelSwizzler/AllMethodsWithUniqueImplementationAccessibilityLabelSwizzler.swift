#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
