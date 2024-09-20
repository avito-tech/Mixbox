#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

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
