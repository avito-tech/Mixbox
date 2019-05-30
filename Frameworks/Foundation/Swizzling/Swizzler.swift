public protocol Swizzler: class {
    func swizzle(
        _ class: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
        -> SwizzlingResult
}

public enum MethodType {
    case instanceMethod
    case classMethod
}
