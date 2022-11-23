#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public protocol Waiter: AnyObject {
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

#endif
