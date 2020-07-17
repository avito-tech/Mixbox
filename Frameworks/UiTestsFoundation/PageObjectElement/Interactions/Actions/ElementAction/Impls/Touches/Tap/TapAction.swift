import MixboxIpcCommon

public final class TapAction: ElementInteraction {
    private let interactionCoordinates: InteractionCoordinates
    
    public init(
        interactionCoordinates: InteractionCoordinates)
    {
        self.interactionCoordinates = interactionCoordinates
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            interactionCoordinates: interactionCoordinates
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let interactionCoordinates: InteractionCoordinates
        
        public init(
            dependencies: ElementInteractionDependencies,
            interactionCoordinates: InteractionCoordinates)
        {
            self.dependencies = dependencies
            self.interactionCoordinates = interactionCoordinates
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
                    try dependencies.snapshotResolver.resolve(interactionCoordinates: interactionCoordinates) { snapshot, pointOnScreen in
                        dependencies.interactionResultMaker.makeResultCatchingErrors {
                            let elementSimpleGestures = try dependencies.elementSimpleGesturesProvider.elementSimpleGestures(
                                elementSnapshot: snapshot,
                                pointOnScreen: pointOnScreen
                            )
                            
                            dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                            try elementSimpleGestures.tap()
                            
                            return .success
                        }
                    }
                }
            }
        }
    }
}
