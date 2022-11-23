#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxIpcCommon

public final class EnhancedAccessibilityLabelMethodSwizzlerImpl: EnhancedAccessibilityLabelMethodSwizzler {
    private let accessibilityLabelFunctionReplacement: AccessibilityLabelFunctionReplacement
    
    public init(accessibilityLabelFunctionReplacement: AccessibilityLabelFunctionReplacement) {
        self.accessibilityLabelFunctionReplacement = accessibilityLabelFunctionReplacement
    }
    
    public func swizzleAccessibilityLabelMethod(method: Method) {
        return replaceAccessibilityValueMethod(method: method)
    }
    
    private func replaceAccessibilityValueMethod(method: Method) {
        // Old implementation
        let originalImplementation = method_getImplementation(method)
        let selector = method_getName(method)
        
        typealias OriginalImplementationFunction = @convention(c) (NSObject?, Selector) -> NSString?
        let originalImplementationFunction = unsafeBitCast(
            originalImplementation,
            to: OriginalImplementationFunction.self
        )
        
        // New implementation
        let newImplementationBlock: @convention(block) (NSObject?) -> NSString? = { [accessibilityLabelFunctionReplacement] this in
            accessibilityLabelFunctionReplacement.accessibilityLabel(this: this) {
                originalImplementationFunction(this, selector)
            }
        }
        let newImplementation = imp_implementationWithBlock(
            unsafeBitCast(newImplementationBlock, to: NSObject.self)
        )
        
        // Apply
        method_setImplementation(method, newImplementation)
    }
}

#endif
