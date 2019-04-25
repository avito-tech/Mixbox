public protocol RunLoopSpinner {
    /**
     *  Spins the current thread's run loop in the active mode using the given stop condition.
     *
     *  Will always spin the run loop for at least the minimum number of run loop drains. Will always
     *  evaluate @c stopConditionBlock at least once after draining for minimum number of drains. After
     *  draining for the minimum number of drains, the spinner will evaluate @c stopConditionBlock at
     *  least once per run loop drain. The spinner will stop initiating drains and return if
     *  @c stopConditionBlock evaluates to @c YES or if the timeout has elapsed.
     *
     *  @remark This method should not be invoked on the same spinner object in nested calls (e.g.
     *          sources that are serviced while it's spinning) or concurrently.
     *
     *  @param stopConditionBlock The condition block used by the spinner to determine if it should
     *                            keep spinning the active run loop.
     *
     *  @return @c YES if the spinner evaluated the @c stopConditionBlock to @c YES; @c NO otherwise.
     */
    func spin(
        until: @escaping () -> Bool)
        -> Bool
}

extension RunLoopSpinner {
    public func spin(
        while: @escaping () -> Bool)
        -> Bool
    {
        return spin(until: { !`while`() })
    }
}
