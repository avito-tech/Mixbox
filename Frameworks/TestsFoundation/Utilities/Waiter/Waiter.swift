public protocol Waiter: class {
    @discardableResult
    func wait(
        timeout: TimeInterval,
        interval: TimeInterval,
        until stopCondition: @escaping () -> (Bool))
        -> SpinUntilResult
}

extension Waiter {
    @discardableResult
    public func wait(
        timeout: TimeInterval,
        until stopCondition: @escaping () -> (Bool))
        -> SpinUntilResult
    {
        return wait(
            timeout: timeout,
            interval: timeout,
            until: stopCondition
        )
    }
    
    @discardableResult
    public func wait(
        timeout: TimeInterval)
        -> SpinUntilResult
    {
        return wait(
            timeout: timeout,
            interval: timeout,
            until: { false }
        )
    }
}
