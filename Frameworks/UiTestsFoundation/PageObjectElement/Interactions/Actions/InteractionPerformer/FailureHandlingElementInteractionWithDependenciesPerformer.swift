import MixboxTestsFoundation
import MixboxFoundation

public final class FailureHandlingElementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer {
    private let nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer,
        testFailureRecorder: TestFailureRecorder)
    {
        self.nestedInteractionPerformer = nestedInteractionPerformer
        self.testFailureRecorder = testFailureRecorder
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
            // E.g.: if tap can not be done, then test will not continue properly
            // if we continue then test we will catch undesired errors
            // if we stop test then developer can focus his attention on error with the action
            let shouldContinueTest = !interaction.interactionFailureShouldStopTest()
            
            testFailureRecorder.recordFailure(
                description: failure.testFailureDescription(),
                fileLine: fileLine,
                shouldContinueTest: shouldContinueTest
            )
        }
        
        return result
    }
}
