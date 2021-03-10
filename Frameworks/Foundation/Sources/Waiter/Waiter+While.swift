#if MIXBOX_ENABLE_IN_APP_SERVICES

extension Waiter {
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

#endif
