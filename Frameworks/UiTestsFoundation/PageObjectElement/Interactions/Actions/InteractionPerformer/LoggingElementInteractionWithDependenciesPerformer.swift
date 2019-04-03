import MixboxReporting
import MixboxFoundation
import MixboxArtifacts

public final class LoggingElementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer {
    private let nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer
    private let stepLogger: StepLogger
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let elementSettings: ElementSettings
    
    public init(
        nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer,
        stepLogger: StepLogger,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        elementSettings: ElementSettings)
    {
        self.nestedInteractionPerformer = nestedInteractionPerformer
        self.stepLogger = stepLogger
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.elementSettings = elementSettings
    }
    
    public func perform(
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine)
        -> InteractionResult
    {
        return logInteraction(interaction: interaction, fileLine: fileLine) {
            nestedInteractionPerformer.perform(
                interaction: interaction,
                fileLine: fileLine
            )
        }
    }
    
    private func logInteraction(
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine,
        body: () -> (InteractionResult))
        -> InteractionResult
    {
        let stepLogBefore = self.stepLogBefore(
            interaction: interaction
        )
        
        let wrapper: StepLoggerResultWrapper<InteractionResult> = stepLogger.logStep(stepLogBefore: stepLogBefore) {
            let interactionResult = body()
            
            return StepLoggerResultWrapper(
                stepLogAfter: stepLogAfter(
                    interaction: interaction,
                    interactionResult: interactionResult,
                    fileLine: fileLine
                ),
                wrappedResult: interactionResult
            )
        }
        
        return wrapper.wrappedResult
    }
    
    // MARK: - Private
    
    private func stepLogBefore(
        interaction: ElementInteractionWithDependencies)
        -> StepLogBefore
    {
        let description = interaction.description()
        
        return StepLogBefore(
            identifyingDescription: description,
            detailedDescription: description,
            stepType: .interaction,
            artifacts: screenshotAttachmentsMaker.makeScreenshotArtifacts(
                beforeStep: true,
                includeHash: false
            )
        )
    }
    
    private func stepLogAfter(
        interaction: ElementInteractionWithDependencies,
        interactionResult: InteractionResult,
        fileLine: FileLine)
        -> StepLogAfter
    {
        let wasSuccessful: Bool
        var stepArtifacts = [Artifact]()
        
        stepArtifacts.append(
            fileLineArtifact(fileLine: fileLine)
        )
        
        switch interactionResult {
        case .success:
            wasSuccessful = true
        case .failure(let interactionFailure):
            stepArtifacts.append(
                Artifact(
                    name: "Сообщение об ошибке",
                    content: .text(interactionFailure.testFailureDescription())
                )
            )
            stepArtifacts.append(contentsOf: interactionFailure.attachments)
            // TODO: Additional attachments?
            wasSuccessful = false
        }
        
        stepArtifacts.append(
            contentsOf: screenshotAttachmentsMaker.makeScreenshotArtifacts(
                beforeStep: false,
                includeHash: !wasSuccessful
            )
        )
        
        return StepLogAfter(
            wasSuccessful: wasSuccessful,
            artifacts: stepArtifacts
        )
    }
    
    private func fileLineArtifact(fileLine: FileLine) -> Artifact {
        return Artifact(
            name: "File and line",
            content: .text("\(fileLine.file):\(fileLine.line)")
        )
    }
}
