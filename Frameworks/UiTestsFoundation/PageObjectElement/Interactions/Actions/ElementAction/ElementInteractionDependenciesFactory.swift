import MixboxFoundation

public protocol ElementInteractionDependenciesFactory: class {
    func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings)
        -> ElementInteractionDependencies
}
