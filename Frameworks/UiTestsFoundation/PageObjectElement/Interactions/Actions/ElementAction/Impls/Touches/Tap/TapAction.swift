public final class TapAction: ElementInteraction {
    private let interactionCoordinates: InteractionCoordinates
    private let minimalPercentageOfVisibleArea: CGFloat
    
    public init(
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.interactionCoordinates = interactionCoordinates
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            interactionCoordinates: interactionCoordinates,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let interactionCoordinates: InteractionCoordinates
        private let minimalPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            interactionCoordinates: InteractionCoordinates,
            minimalPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.interactionCoordinates = interactionCoordinates
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        }
        
        public func description() -> String {
            return "тапнуть по \"\(dependencies.elementInfo.elementName)\""
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [interactionCoordinates, dependencies] _ in
                dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.applicationQuiescenceWaiter.waitForQuiescence {
                        dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
                            dependencies.interactionResultMaker.makeResultCatchingErrors {
                                let elementSimpleGestures = try dependencies.elementSimpleGesturesProvider.elementSimpleGestures(
                                    elementSnapshot: snapshot,
                                    interactionCoordinates: interactionCoordinates
                                )
                                
                                dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                                try elementSimpleGestures.tap()
                                
                                return  .success
                            }
                        }
                    }
                }
            }
        }
    }
}
