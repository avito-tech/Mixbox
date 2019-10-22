#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpcCommon

public final class EnhancedAccessibilityLabelMethodSwizzlerImpl: EnhancedAccessibilityLabelMethodSwizzler {
    public init() {
    }
    
    // TODO: Rewrite using AssertinSwizzler? It will require to switch input arguments from
    // Method to AnyClass and Selector and may work slower.
    public func swizzleAccessibilityLabelMethod(method: Method) {
        return replaceAccessibilityValueMethod(method: method)
    }
    
    private func replaceAccessibilityValueMethod(method: Method) {
        // Old implementation
        let originalImplementation = method_getImplementation(method)
        let selector = method_getName(method)
        
        // swiftlint:disable:next nesting
        typealias OriginalImplementationFunction = @convention(c) (NSObject?, Selector) -> NSString?
        let originalImplementationFunction = unsafeBitCast(
            originalImplementation,
            to: OriginalImplementationFunction.self
        )
        
        // New implementation
        let newImplementationBlock: @convention(block) (NSObject?) -> NSString? = { this in
            self.enchancedAccessibilityLabel(this: this) {
                originalImplementationFunction(this, selector)
            }
        }
        let newImplementation = imp_implementationWithBlock(
            unsafeBitCast(newImplementationBlock, to: NSObject.self)
        )
        
        // Apply
        method_setImplementation(method, newImplementation)
    }
    
    @objc fileprivate func enchancedAccessibilityLabel(
        this: NSObject?,
        originalImplementation: () -> NSString?)
        -> NSString?
    {
        let unwrappedOriginalAccessibilityLabel = unwrapAccessibilityLabel(
            originalAccessibilityLabel: originalImplementation()
        )
        
        guard let view = this as? UIView else {
            return unwrappedOriginalAccessibilityLabel
        }
        
        let label = EnhancedAccessibilityLabel(
            originalAccessibilityLabel: unwrappedOriginalAccessibilityLabel as String?,
            accessibilityValue: view.accessibilityValue,
            uniqueIdentifier: view.uniqueIdentifier,
            isDefinitelyHidden: view.isDefinitelyHidden,
            text: view.testabilityValue_text(),
            customValues: view.testability_customValues.dictionary
        )
        
        AccessibilityUniqueObjectMap.shared.register(object: view)
        
        return (label.toAccessibilityLabel() as NSString?) ?? unwrappedOriginalAccessibilityLabel
    }
    
    // TODO: Eliminate the need of unwrapping the value. It is necessary for iOS 9/10.
    private func unwrapAccessibilityLabel(
        originalAccessibilityLabel: NSString?)
        -> NSString?
    {
        var originalAccessibilityLabel = originalAccessibilityLabel
        
        if originalAccessibilityLabel == nil {
            return nil
        }
        
        while let label = EnhancedAccessibilityLabel.fromAccessibilityLabel(originalAccessibilityLabel as String?) {
            originalAccessibilityLabel = label.originalAccessibilityLabel as NSString?
        }
        
        return originalAccessibilityLabel
    }
}

#endif
