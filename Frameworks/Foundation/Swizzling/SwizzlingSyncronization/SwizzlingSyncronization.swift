public protocol SwizzlingSyncronization: class {
    func append(
        swizzlingResult: SwizzlingResult,
        shouldAssertIfMethodIsSwizzledOnlyOneTime: Bool)
        -> ErrorString?
}
