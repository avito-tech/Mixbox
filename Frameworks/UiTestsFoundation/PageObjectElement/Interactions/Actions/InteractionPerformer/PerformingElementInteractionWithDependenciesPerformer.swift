import MixboxFoundation
import MixboxTestsFoundation

public final class PerformingElementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer {
    public init() {
    }
    
    public func perform(
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine)
        -> InteractionResult
    {
        let result = interaction.perform()
     
        // TODO: Move this logic to another class?
        switch result {
        case .success:
            return .success
        case .failure(let failureToBeNested):
            let failure = InteractionFailure(
                message: """
                "\(interaction.description())" неуспешно
                """,
                attachments: [],
                nestedFailures: [failureToBeNested]
            )
            
            return .failure(failure)
        }
    }
}
