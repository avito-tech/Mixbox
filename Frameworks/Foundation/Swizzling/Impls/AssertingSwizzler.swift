// TODO: DI
public final class AssertingSwizzler {
    private let swizzler = SwizzlerImpl()
    
    private static let swizzlingSyncronization = SwizzlingSyncronizationImpl()
    
    public init() {
    }
    
    public func swizzle(
        _ class: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
    {
        let swizzlingResult = swizzler.swizzle(`class`, originalSelector, swizzledSelector, methodType)
        if let error = AssertingSwizzler.swizzlingSyncronization.append(swizzlingResult: swizzlingResult) {
            assertionFailure(error.value)
        }
    }
}
