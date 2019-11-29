public class PressAction: ElementInteraction {
    private let duration: TimeInterval
    private let interactionCoordinates: InteractionCoordinates
    private let minimalPercentageOfVisibleArea: CGFloat
    
    public init(
        duration: TimeInterval,
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.duration = duration
        self.interactionCoordinates = interactionCoordinates
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            duration: duration,
            interactionCoordinates: interactionCoordinates,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let duration: TimeInterval
        private let interactionCoordinates: InteractionCoordinates
        private let minimalPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            duration: TimeInterval,
            interactionCoordinates: InteractionCoordinates,
            minimalPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.duration = duration
            self.interactionCoordinates = interactionCoordinates
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        }
        
        public func description() -> String {
            return "нажать \"\(dependencies.elementInfo.elementName)\" и удерживать \(duration) секунд"
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [interactionCoordinates, duration, dependencies] _ in
                dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.applicationQuiescenceWaiter.waitForQuiescence {
                        dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { snapshot in
                            do {
                                let elementSimpleGestures = try dependencies.elementSimpleGesturesProvider.elementSimpleGestures(
                                    elementSnapshot: snapshot,
                                    interactionCoordinates: interactionCoordinates
                                )
                                
                                dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                                try elementSimpleGestures.press(duration: duration)
                                
                                return .success
                            } catch {
                                return dependencies.interactionResultMaker.failure(message: "\(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}
