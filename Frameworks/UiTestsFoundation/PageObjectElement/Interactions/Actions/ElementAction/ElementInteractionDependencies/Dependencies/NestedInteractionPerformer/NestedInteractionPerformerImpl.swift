import MixboxFoundation

public final class NestedInteractionPerformerImpl: NestedInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer
    private let retriableTimedInteractionState: RetriableTimedInteractionState
    private let elementSettings: ElementSettings
    private let fileLine: FileLine
    
    public init(
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings,
        fileLine: FileLine)
    {
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementInteractionWithDependenciesPerformer = elementInteractionWithDependenciesPerformer
        self.retriableTimedInteractionState = retriableTimedInteractionState
        self.elementSettings = elementSettings
        self.fileLine = fileLine
    }
    
    public func perform(interaction: ElementInteraction) -> InteractionResult {
        let elementInteractionDependencies = elementInteractionDependenciesFactory.elementInteractionDependencies(
            interaction: interaction,
            fileLine: fileLine,
            elementInteractionWithDependenciesPerformer: elementInteractionWithDependenciesPerformer,
            retriableTimedInteractionState: retriableTimedInteractionState,
            elementSettings: elementSettings
        )
        
        let elementInteractionWithDependencies = interaction.with(
            dependencies: elementInteractionDependencies
        )
        
        return elementInteractionWithDependenciesPerformer.perform(
            interaction: elementInteractionWithDependencies,
            fileLine: fileLine
        )
    }
}
