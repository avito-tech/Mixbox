// TODO: DI
public final class AssertingSwizzler {
    private let swizzler = SwizzlerImpl()
    
    private static let swizzlingSyncronization = SwizzlingSyncronizationImpl()
    
    public init() {
    }
    
    public func swizzle(
        class: NSObject.Type,
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
        file: StaticString = #file,
        line: UInt = #line)
    {
        let swizzlingResult = swizzler.swizzle(`class`, originalSelector, swizzledSelector, methodType)
        
        let errorOrNil = AssertingSwizzler.swizzlingSyncronization.append(
            swizzlingResult: swizzlingResult,
            shouldAssertIfMethodIsSwizzledOnlyOneTime: shouldAssertIfMethodIsSwizzledOnlyOneTime
        )
        
        if let error = errorOrNil {
            assertionFailure(error.value, file: file, line: line)
        }
    }
}
