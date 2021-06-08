#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol SwizzlingSynchronization: AnyObject {
    func append(
        swizzlingResult: SwizzlingResult,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
        -> ErrorString?
}

#endif
