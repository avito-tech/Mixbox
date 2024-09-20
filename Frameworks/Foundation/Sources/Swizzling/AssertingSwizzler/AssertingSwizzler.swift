#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public protocol AssertingSwizzler: AnyObject {
    func swizzle(
        originalClass: NSObject.Type,
        swizzlingClass: NSObject.Type,
        originalSelector: Selector,
        swizzledSelector: Selector,
        methodType: MethodType,
        // Very stupid way to cope with multiple swizzlings of same method.
        // UIAccessibilityContainer methods (accessibilityElementCount) are swizzled for CollectionView and
        // CollectionViewCell. On some iOS versions they point to a single implementation in UIView,
        // so we need to disable the assertion. Maybe it would be a better solution to add new method for
        // CollectionView/CollectionViewCell if it doesn't exist. I didn't do it, because obviously it requires
        // me to write some code, but also I'm afraid of adding new method, because it is more invasive than swizzling
        // (some kludges in UIKit or other libraries may break because of it).
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool,
        fileLine: FileLine)
}

public extension AssertingSwizzler {
    func swizzle(
        class: NSObject.Type,
        originalSelector: Selector,
        swizzledSelector: Selector,
        methodType: MethodType,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
    {
        swizzle(
            originalClass: `class`,
            swizzlingClass: `class`,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: methodType,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime
        )
    }
    
    func swizzle(
        originalClass: NSObject.Type,
        swizzlingClass: NSObject.Type,
        originalSelector: Selector,
        swizzledSelector: Selector,
        methodType: MethodType,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        self.swizzle(
            originalClass: originalClass,
            swizzlingClass: swizzlingClass,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector,
            methodType: methodType,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime,
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
}

#endif
