#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisibilityCheckForLoopOptimizerFactoryImpl: VisibilityCheckForLoopOptimizerFactory {
    private let numberOfPointsInGrid: Int
    
    public init(numberOfPointsInGrid: Int) {
        self.numberOfPointsInGrid = numberOfPointsInGrid
    }
    
    public func visibilityCheckForLoopOptimizer(useHundredPercentAccuracy: Bool) -> VisibilityCheckForLoopOptimizer {
        return VisibilityCheckForLoopOptimizerImpl(
            numberOfPointsInGrid: numberOfPointsInGrid,
            useHundredPercentAccuracy: useHundredPercentAccuracy
        )
    }
}

#endif
