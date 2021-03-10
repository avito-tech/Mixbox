import MixboxFoundation

public final class NestedInteractionPerformerImpl: NestedInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer
    private let retriableTimedInteractionState: RetriableTimedInteractionState
    private let elementSettings: ElementSettings
    private let fileLine: FileLine
    private let performanceLogger: PerformanceLogger
    
    public init(
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer,
        retriableTimedInteractionState: RetriableTimedInteractionState,
        elementSettings: ElementSettings,
        fileLine: FileLine,
        performanceLogger: PerformanceLogger)
    {
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementInteractionWithDependenciesPerformer = elementInteractionWithDependenciesPerformer
        self.retriableTimedInteractionState = retriableTimedInteractionState
        self.elementSettings = elementSettings
        self.fileLine = fileLine
        self.performanceLogger = performanceLogger
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
        return performanceLogger.log(
            staticName: "nested interaction",
            dynamicName: { "\(interactionType)" },
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
            retriableTimedInteractionState: retriableTimedInteractionState.retriableTimedInteractionStateForNestedRetryOperation(),
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
