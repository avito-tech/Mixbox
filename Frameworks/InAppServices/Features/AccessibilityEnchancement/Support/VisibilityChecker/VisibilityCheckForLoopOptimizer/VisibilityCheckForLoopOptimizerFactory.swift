#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol VisibilityCheckForLoopOptimizerFactory {
    func visibilityCheckForLoopOptimizer(
        useHundredPercentAccuracy: Bool)
        -> VisibilityCheckForLoopOptimizer
}

#endif
