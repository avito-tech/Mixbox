import MixboxIpcCommon

// Expected effect:
//     One of:
//         - Keyboard is focused on a text field.
//         - Fail
//
// If you do not want to be sure that focus is gained, use pure TapAction.
//
public final class FocusKeyboardOnElementAction: ElementInteraction {
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
            return """
                сфокусироваться на элементе "\(dependencies.elementInfo.elementName)"
                """
        }
        
        public func interactionFailureShouldStopTest() -> Bool {
            return true
        }
        
        // TODO: Can be replaced with AndElementInteraction + some retrier
        public func perform() -> InteractionResult {
            return dependencies.interactionRetrier.retryInteractionUntilTimeout { _ in
                let result = dependencies.interactionPerformer.perform(
                    interaction: TapAction(
                        interactionCoordinates: interactionCoordinates
                    )
                )
                
                if result.wasFailed {
                    return result
                } else {
                    return dependencies.interactionPerformer.perform(
                        interaction: IsDisplayedAndMatchesCheck(
                            overridenPercentageOfVisibleArea: nil,
                            matcher: HasKeyboardFocusOrHasDescendantThatHasKeyboardFocusElementSnapshotMatcher()
                        )
                    )
                }
            }
        }
    }
}
