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
            return dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { [interactionCoordinates, duration, dependencies] snapshot in
                do {
                    let elementSimpleGestures = try dependencies.elementSimpleGesturesProvider.elementSimpleGestures(
                        elementSnapshot: snapshot,
                        interactionCoordinates: interactionCoordinates
                    )
                    
                    dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                    elementSimpleGestures.press(duration: duration)
                    
                    return .success
                } catch let e {
                    return dependencies.interactionResultMaker.failure(message: "\(e)")
                }
            }
        }
    }
}

