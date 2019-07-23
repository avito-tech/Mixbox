#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol Swizzler: class {
    func swizzle(
        _ class: NSObject.Type,
        _ originalSelector: Selector,
        _ swizzledSelector: Selector,
        _ methodType: MethodType)
        -> SwizzlingResult
}

#endif
