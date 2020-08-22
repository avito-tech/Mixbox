import MixboxTestsFoundation
import MixboxFoundation

public final class FailureHandlingElementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer {
    private let nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer
    private let testFailureRecorder: TestFailureRecorder
    private let interactionFailureDebugger: InteractionFailureDebugger
    
    public init(
        nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer,
        testFailureRecorder: TestFailureRecorder,
        interactionFailureDebugger: InteractionFailureDebugger)
    {
        self.nestedInteractionPerformer = nestedInteractionPerformer
        self.testFailureRecorder = testFailureRecorder
        self.interactionFailureDebugger = interactionFailureDebugger
    }
    
    public func perform(
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine)
        -> InteractionResult
    {
        let result = nestedInteractionPerformer.perform(
            interaction: interaction,
            fileLine: fileLine
        )
        
        if let failure = result.failure {
            do {
                let result = try interactionFailureDebugger.performDebugging()
                
                switch result {
                case .failureWasFixed:
                    break
                case .failureWasNotFixed:
                    fail(
                        message: failure.testFailureDescription(),
                        interaction: interaction,
                        fileLine: fileLine
                    )
                }
            } catch {
                fail(
                    message:
                    """
                    Interaction has failed and the attempt to debug failure has also failed with error: \(error). \
                    Interaction failure: \(failure.testFailureDescription()).
                    """,
                    interaction: interaction,
                    fileLine: fileLine
                )
            }
        }
        
        return result
    }
    
    private func fail(
        message: String,
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine)
    {
        // E.g.: if tap can not be done, then test will not continue properly
        // if we continue then test we will catch undesired errors
        // if we stop test then developer can focus his attention on error with the action
        let shouldContinueTest = !interaction.interactionFailureShouldStopTest()
        
        testFailureRecorder.recordFailure(
            description: message,
            fileLine: fileLine,
            shouldContinueTest: shouldContinueTest
        )
    }
}
