public protocol Spinner: class {
    @discardableResult
    func spin(
        timeout: TimeInterval,
        interval: TimeInterval,
        until stopCondition: @escaping () -> (Bool))
        -> SpinUntilResult
}

extension Spinner {
    @discardableResult
    public func spin(
        timeout: TimeInterval,
        until: @escaping () -> (Bool))
        -> SpinUntilResult
    {
        return spin(timeout: timeout, interval: timeout, until: until)
    }
    
    @discardableResult
    public func spin(
        timeout: TimeInterval)
        -> SpinUntilResult
    {
        return spin(timeout: timeout, interval: timeout, until: { false })
    }
}
