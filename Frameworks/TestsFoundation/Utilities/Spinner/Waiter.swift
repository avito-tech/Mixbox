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
    
    @discardableResult
    public func wait(
        timeout: TimeInterval,
        interval: TimeInterval,
        while continueCondition: @escaping () -> Bool)
        -> SpinWhileResult
    {
        let result = wait(
            timeout: timeout,
            interval: interval,
            until: {
                !continueCondition()
            }
        )
        
        switch result {
        case .stopConditionMet:
            return .continueConditionStoppedBeingMet
        case .timedOut:
            return .timedOut
        }
    }
    
    @discardableResult
    public func wait(
        timeout: TimeInterval,
        while continueCondition: @escaping () -> Bool)
        -> SpinWhileResult
    {
        return wait(
            timeout: timeout,
            interval: timeout,
            while: continueCondition
        )
    }
}
