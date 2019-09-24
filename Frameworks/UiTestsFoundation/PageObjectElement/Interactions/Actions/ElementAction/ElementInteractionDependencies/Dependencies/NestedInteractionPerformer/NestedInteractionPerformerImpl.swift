import MixboxFoundation

public final class NestedInteractionPerformerImpl: NestedInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer
    private let retriableTimedInteractionState: RetriableTimedInteractionState
    private let elementSettings: ElementSettings
    private let fileLine: FileLine
    private let signpostActivityLogger: SignpostActivityLogger
    
    public init(
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings,
        fileLine: FileLine,
        signpostActivityLogger: SignpostActivityLogger)
    {
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementInteractionWithDependenciesPerformer = elementInteractionWithDependenciesPerformer
        self.retriableTimedInteractionState = retriableTimedInteractionState
        self.elementSettings = elementSettings
        self.fileLine = fileLine
        self.signpostActivityLogger = signpostActivityLogger
    }
    
    public func perform(
        interaction: ElementInteraction)
        -> InteractionResult
    {
        return logPerformance(interactionType: type(of: interaction)) {
            performWhileLoggingPerformance(
                interaction: interaction
            )
        }
    }
    
    // MARK: - Private
    
    private func logPerformance<T>(interactionType: ElementInteraction.Type, body: () -> T) -> T {
        return signpostActivityLogger.log(
            name: "performing nested interaction",
            message: { "\(interactionType)" },
            body: body
        )
    }
    
    private func performWhileLoggingPerformance(
        interaction: ElementInteraction)
        -> InteractionResult
    {
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
