// The high level logic of interaction that doesn't know anything about how to perform low-level access to UI,
// perform touches, etc. Is used to share logic between XCUI/GrayBox testing.
//
// TODO: Rename?
//
//       Example:
//
//       ElementInteraction => ElementInteractionLogic
//       ElementInteractionWithDependencies => ElementInteraction
//
//       ElementInteraction => ElementInteractionFactory
//       ElementInteractionWithDependencies => ElementInteraction
//
public protocol ElementInteraction: AnyObject {
    func with(dependencies: ElementInteractionDependencies) -> ElementInteractionWithDependencies
}

public protocol ElementInteractionWithDependencies: AnyObject {
    // Return false if test can continue if interaction is failed (useful for tests with lots of checks)
    // TODO: Refactor. Maybe we should put it inside InteractionResult. Or outside of interaction.
    func interactionFailureShouldStopTest() -> Bool
    
    func description() -> String
    
    // NOTE: Don't call directly, use ElementInteractionPerformer
    func perform() -> InteractionResult
}
