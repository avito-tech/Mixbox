#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxTestability

final class AccessibilityValueSwizzler {
    static func setUp() {
        let os = UIDevice.current.mb_iosVersion.majorVersion
        switch os {
        case 9, 10:
            swizzleForIos9or10()
        case 11, 12:
            swizzleForIos11or12()
        default:
            assertionFailure("Unknown iOS \(os), make sure that accessibilityValue is swizzled correctly")
        }
    }
    
    // MARK: - Implementation for different iOS versions
    
    private static func swizzleForIos9or10() {
        // VERY slow way. Wastes 1-3 seconds at the start.
        // It is universal for all iOS versions.
        //
        // Pros (compared to iOS 11 version):
        // - it definately works with every accessibilityValue method (there are ~350 implementations in runtime)
        // Cons:
        // - affects much more methods, also accessibilyValue can be passed to other accessibilyValue
        //   with our changed value. E.g: someView.accessibilityValue = someOtherView.accessibilityValue
        //   However, there's a defense from that. The excessive nesting of the value inside other value
        //   is solved by unwrapping it in a while loop.
        //
        // There's no method named _accessibilityAXAttributedValue in iOS 9 (and on iOS 10),
        // so we swizzle all implementations of accessibilityValue (~300..350).
        //
        // It seems possible in future to find a single place (like _accessibilityAXAttributedValue) and swizzle there, for iOS 9, if we didn't stop supporting iOS 9.
        // How to start that research: swizzle accessibilityValue of UILabel, set a breakpoint in
        // enhancedAccessibilityValue and inspect the stacktrace. At the moment this comment is written,
        // there were no suitable functions without arguments in the stacktrace. However, functions
        // with arguments can also suit. I just didn't find time for that.
        
        swizzleAllAccessibilityValueMethods()
    }
    
    private static func swizzleAllAccessibilityValueMethods() {
        let accessibilityValueMethods = allMethodsWithUniqueImplementation(
            selector: #selector(NSObject.accessibilityValue),
            baseClass: NSObject.self
        )
        for method in accessibilityValueMethods {
            replaceAccessibilityValueMethod(method: method)
        }
    }
    
    private static func swizzleForIos11or12() {
        // Unlike iOS 9 or 10, there's a way to swizzle only few methods.
        // Pros: much much faster
        // Cons: We are not sure that it is enough. However, it worked for 6+ month without any problem.
        
        var classesAndSelectors = [(class: AnyClass, selector: Selector)]()
        let _accessibilityAXAttributedValueSelector = Selector(("_accessibilityAXAttributedValue"))
        
        classesAndSelectors.append((
            class: NSObject.self,
            selector: _accessibilityAXAttributedValueSelector
        ))
        
        if let aClass = NSClassFromString("UIAccessibilityTextFieldElement") {
            classesAndSelectors.append((
                class: aClass,
                selector: _accessibilityAXAttributedValueSelector
            ))
        }
        
        for (aClass, selector) in classesAndSelectors {
            if let method = class_getInstanceMethod(aClass, selector) {
                replaceAccessibilityValueMethod(method: method)
            }
        }
    }
    
    // MARK: - Swizzling
    
    private static func replaceAccessibilityValueMethod(method: Method) {
        // Old implementation
        let originalImplementation = method_getImplementation(method)
        typealias OriginalImplementationFunction = @convention(c) (NSObject?, Selector) -> NSString?
        let originalImplementationFunction = unsafeBitCast(
            originalImplementation,
            to: OriginalImplementationFunction.self
        )
        
        // New implementation
        let newImplementationBlock: @convention(block) (NSObject?) -> NSString? = { this in
            enhancedAccessibilityValue(this: this) {
                originalImplementationFunction(this, #selector(NSObject.accessibilityValue))
            }
        }
        let newImplementation = imp_implementationWithBlock(
            unsafeBitCast(newImplementationBlock, to: NSObject.self)
        )
        
        // Apply
        method_setImplementation(method, newImplementation)
    }
    
    private static func allMethodsWithUniqueImplementation(
        selector: Selector,
        baseClass: AnyClass)
        -> [Method]
    {
        var uniqueMethods = Set<Method>()
        
        var count = UInt32(0)
        guard let classList = objc_copyClassList(&count) else {
            return []
        }
        
        for i in 0..<Int(count) {
            let method = class_getInstanceMethod(classList[i], selector)
            
            if let method = method {
                uniqueMethods.insert(method)
            }
        }
        
        return Array(uniqueMethods)
    }
    
    // MARK: - EnhancedAccessibilityValue
    
    private static func enhancedAccessibilityValue(
        this: NSObject?,
        originalImplementation: () -> (NSString?)) -> NSString?
    {
        let originalAccessibilityValue = unwrapAccessibilityValue(originalImplementation)
        guard let view = this as? UIView else {
            return originalAccessibilityValue
        }
        
        let value = EnhancedAccessibilityValue(
            originalAccessibilityValue: originalAccessibilityValue as String,
            uniqueIdentifier: view.uniqueIdentifier,
            isDefinitelyHidden: view.isDefinitelyHidden,
            visibleText: view.testabilityValue_visibleText(),
            customValues: view.testability_customValues.dictionary
        )
        
        AccessibilityUniqueObjectMap.shared.register(object: view)
        
        return (value.toAccessibilityValue() as NSString?) ?? originalAccessibilityValue
    }
    
    // TODO: Eliminate the need of unwrapping the value. See swizzleForIos9or10.
    private static func unwrapAccessibilityValue(_ originalImplementation: () -> (NSString?)) -> NSString {
        guard var originalAccessibilityValue = originalImplementation() else {
            return ""
        }
        
        while let value = EnhancedAccessibilityValue.fromAccessibilityValue(originalAccessibilityValue as String) {
            originalAccessibilityValue = (value.originalAccessibilityValue as NSString?) ?? ""
        }
        
        return originalAccessibilityValue
    }
}

#endif
