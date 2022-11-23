#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public protocol RunLoopSpinner: AnyObject {
    // Spins the current thread's run loop in the active mode using the given stop condition.
    //
    // Will always spin the run loop for at least the minimum number of run loop drains. Will always
    // evaluate `stopCondition` at least once after draining for minimum number of drains. After
    // draining for the minimum number of drains, the spinner will evaluate `stopCondition` at
    // least once per run loop drain. The spinner will stop initiating drains and return if
    // `stopCondition` evaluates to `true` or if the timeout has elapsed.
    //
    // This method should not be invoked on the same spinner object in nested calls (e.g.
    // sources that are serviced while it's spinning) or concurrently.
    // TODO: Compile-time improvements / run-time check?
    //
    func spinUntil(
        stopCondition: @escaping () -> Bool)
        -> SpinUntilResult
}

extension RunLoopSpinner {
    public func spinWhile(
        continueCondition: @escaping () -> Bool)
        -> SpinWhileResult
    {
        let result = spinUntil {
            !continueCondition()
        }
        
        switch result {
        case .stopConditionMet:
            return .continueConditionStoppedBeingMet
        case .timedOut:
            return .timedOut
        }
    }
}

#endif
