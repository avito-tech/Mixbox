import MixboxFoundation

// TODO: Use runtime DI
public protocol ElementInteractionDependenciesFactory: AnyObject {
    func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings,
        interactionSettings: InteractionSettings)
        -> ElementInteractionDependencies
}
