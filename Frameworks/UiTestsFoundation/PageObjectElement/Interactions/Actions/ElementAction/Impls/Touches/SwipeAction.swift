import MixboxUiKit

public final class SwipeAction: ElementInteraction {
    private let direction: SwipeDirection
    private let interactionCoordinates: InteractionCoordinates
    private let minimalPercentageOfVisibleArea: CGFloat
    
    public init(
        direction: SwipeDirection,
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        self.direction = direction
        self.interactionCoordinates = interactionCoordinates
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            direction: direction,
            interactionCoordinates: interactionCoordinates,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let direction: SwipeDirection
        private let interactionCoordinates: InteractionCoordinates
        private let minimalPercentageOfVisibleArea: CGFloat
        
        public init(
            dependencies: ElementInteractionDependencies,
            direction: SwipeDirection,
            interactionCoordinates: InteractionCoordinates,
            minimalPercentageOfVisibleArea: CGFloat)
        {
            self.dependencies = dependencies
            self.direction = direction
            self.interactionCoordinates = interactionCoordinates
            self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        }
    
        public func description() -> String {
            let localizedDirection: String
            
            switch direction {
            case .up:
                localizedDirection = "вверх"
            case .down:
                localizedDirection = "вниз"
            case .left:
                localizedDirection = "влево"
            case .right:
                localizedDirection = "вправо"
            }
            
            return "в \(dependencies.elementInfo.elementName) свайп \(localizedDirection)"
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            return dependencies.snapshotResolver.resolve(minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea) { [direction, dependencies] snapshot in
                let swipeLength: CGFloat = 100
                let delta = WithDependencies.normalizedOffsetForSwipe(direction: direction) * swipeLength
                let origin = snapshot.frameOnScreen.mb_center
                
                dependencies.retriableTimedInteractionState.markAsImpossibleToRetry()
                dependencies.eventGenerator.pressAndDrag(
                    from: origin,
                    to: origin + delta,
                    duration: 0,
                    velocity: 1000 // TODO: Do it faster?
                )
                
                return .success
            }
        }
        
        private static func normalizedOffsetForSwipe(direction: SwipeDirection) -> CGVector {
            let dxNormalized: CGFloat
            let dyNormalized: CGFloat
            
            switch direction {
            case .up:
                dxNormalized = 0
                dyNormalized = -1
            case .down:
                dxNormalized = 0
                dyNormalized = 1
            case .left:
                dxNormalized = -1
                dyNormalized = 0
            case .right:
                dxNormalized = 1
                dyNormalized = 0
            }
            
            return CGVector(
                dx: dxNormalized,
                dy: dyNormalized
            )
        }
    }
}
