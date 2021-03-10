import MixboxTestsFoundation
import MixboxFoundation

public final class LoggingElementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer {
    private let nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer
    private let stepLogger: StepLogger
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let elementSettings: ElementSettings
    private let dateProvider: DateProvider
    
    public init(
        nestedInteractionPerformer: ElementInteractionWithDependenciesPerformer,
        stepLogger: StepLogger,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        elementSettings: ElementSettings,
        dateProvider: DateProvider)
    {
        self.nestedInteractionPerformer = nestedInteractionPerformer
        self.stepLogger = stepLogger
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.elementSettings = elementSettings
        self.dateProvider = dateProvider
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
        return StepLogBefore(
            date: dateProvider.currentDate(),
            title: interaction.description(),
            attachments: screenshotAttachmentsMaker.makeScreenshotAttachments(
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
        var stepAttachments = [Attachment]()
        
        stepAttachments.append(
            fileLineAttachment(fileLine: fileLine)
        )
        
        switch interactionResult {
        case .success:
            wasSuccessful = true
        case .failure(let interactionFailure):
            stepAttachments.append(
                Attachment(
                    name: "Сообщение об ошибке",
                    content: .text(interactionFailure.testFailureDescription())
                )
            )
            stepAttachments.append(contentsOf: allAttachments(interactionFailure: interactionFailure))
            // TODO: Additional attachments?
            wasSuccessful = false
        }
        
        stepAttachments.append(
            contentsOf: screenshotAttachmentsMaker.makeScreenshotAttachments(
                beforeStep: false,
                includeHash: !wasSuccessful
            )
        )
        
        return StepLogAfter(
            date: dateProvider.currentDate(),
            wasSuccessful: wasSuccessful,
            attachments: stepAttachments
        )
    }
    
    private func allAttachments(interactionFailure: InteractionFailure) -> [Attachment] {
        return interactionFailure.attachments + interactionFailure.nestedFailures.flatMap {
            allAttachments(interactionFailure: $0)
        }
    }
    
    private func fileLineAttachment(fileLine: FileLine) -> Attachment {
        return Attachment(
            name: "File and line",
            content: .text("\(fileLine.file):\(fileLine.line)")
        )
    }
}
