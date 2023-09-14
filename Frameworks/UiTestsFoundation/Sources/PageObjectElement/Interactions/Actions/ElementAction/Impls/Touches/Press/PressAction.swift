import MixboxIpcCommon
import Foundation

public class PressAction: ElementInteraction {
    private let duration: TimeInterval
    private let interactionCoordinates: InteractionCoordinates
    
    public init(
        duration: TimeInterval,
        interactionCoordinates: InteractionCoordinates)
    {
        self.duration = duration
        self.interactionCoordinates = interactionCoordinates
    }
    
    public func with(
        dependencies: ElementInteractionDependencies)
        -> ElementInteractionWithDependencies
    {
        return WithDependencies(
            dependencies: dependencies,
            duration: duration,
            interactionCoordinates: interactionCoordinates
        )
    }
    
    public final class WithDependencies: ElementInteractionWithDependencies {
        private let dependencies: ElementInteractionDependencies
        private let duration: TimeInterval
        private let interactionCoordinates: InteractionCoordinates
        
        public init(
            dependencies: ElementInteractionDependencies,
            duration: TimeInterval,
            interactionCoordinates: InteractionCoordinates)
        {
            self.dependencies = dependencies
            self.duration = duration
            self.interactionCoordinates = interactionCoordinates
        }
        
        public func description() -> String {
            """
            tap "\(dependencies.elementInfo.elementName)" and hold \(duration) seconds
            """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { [interactionCoordinates, duration, dependencies] _ in
                dependencies.interactionResultMaker.makeResultCatchingErrors {
                    try dependencies.snapshotResolver.resolve(interactionCoordinates: interactionCoordinates) { snapshot, pointOnScreen in
                        do {
                            let elementSimpleGestures = try dependencies.elementSimpleGesturesProvider.elementSimpleGestures(
                                elementSnapshot: snapshot,
                                pointOnScreen: pointOnScreen
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
