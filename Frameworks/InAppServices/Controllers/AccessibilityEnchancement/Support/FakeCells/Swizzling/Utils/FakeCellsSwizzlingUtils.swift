final class FakeCellsSwizzlingUtils {
    static func swizzle(
        _ class: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector)
        -> FakeCellSwizzlingResult
    {
        guard let originalMethod = class_getInstanceMethod(`class`, originalSelector) else {
            return .failedToGetOriginalMethod(`class`, originalSelector)
        }
        guard let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector) else {
            return .failedToGetSwizzledMethod(`class`, swizzledSelector)
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        
        return .swizzledOriginalMethod(originalMethod)
    }
}
