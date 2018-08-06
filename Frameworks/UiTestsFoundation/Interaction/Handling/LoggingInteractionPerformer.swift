import MixboxTestsFoundation
import MixboxReporting

public final class LoggingInteractionPerformer: InteractionPerformer {
    private let wrappedInteractionPerformer: InteractionPerformer
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        wrappedInteractionPerformer: InteractionPerformer,
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder)
    {
        self.wrappedInteractionPerformer = wrappedInteractionPerformer
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func performInteraction(interaction: Interaction) -> InteractionResult {
        let result = interactionExecutionLogger.logInteraction(interactionDescription: interaction.description) {
            wrappedInteractionPerformer.performInteraction(interaction: interaction)
        }
        
        if let failure = result.failure {
            let shouldContinueTest: Bool
            
            switch interaction.description.type {
            case .action:
                // if action can not be done, then test will not continue properly
                // if we continue test we will catch undesired errors
                // if we stop test then developer can focus his attention on error with the action
                shouldContinueTest = false
            case .check:
                // test will continue and developer may see failures in other checks
                shouldContinueTest = true
            }
            
            testFailureRecorder.recordFailure(
                description: failure.message,
                fileLine: interaction.description.settings.fileLineWhereExecuted,
                shouldContinueTest: shouldContinueTest
            )
        }
        
        return result
    }
}
