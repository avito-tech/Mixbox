import MixboxFoundation
import MixboxTestsFoundation

public final class PageObjectElementInteractionPerformerImpl: PageObjectElementInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementSettings: ElementSettings
    private let testFailureRecorder: TestFailureRecorder
    private let dateProvider: DateProvider
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    private let signpostActivityLogger: SignpostActivityLogger
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementSettings: ElementSettings,
        signpostActivityLogger: SignpostActivityLogger)
    {
        self.testFailureRecorder = testFailureRecorder
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementSettings = elementSettings
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
        self.signpostActivityLogger = signpostActivityLogger
    }
    
    public func perform(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
    {
        return logPerformance(interactionType: type(of: interaction)) {
            performWhileLoggingPerformance(
                interaction: interaction,
                interactionPerformingSettings: interactionPerformingSettings
            )
        }
    }
    
    public func with(settings: ElementSettings) -> PageObjectElementInteractionPerformer {
        return PageObjectElementInteractionPerformerImpl(
            testFailureRecorder: testFailureRecorder,
            screenshotAttachmentsMaker: screenshotAttachmentsMaker,
            stepLogger: stepLogger,
            dateProvider: dateProvider,
            elementInteractionDependenciesFactory: elementInteractionDependenciesFactory,
            elementSettings: settings,
            signpostActivityLogger: signpostActivityLogger
        )
    }
    
    // MARK: - Private
    
    private func logPerformance<T>(interactionType: ElementInteraction.Type, body: () -> T) -> T {
        return signpostActivityLogger.log(
            name: "performing root interaction",
            message: { "\(interactionType)" },
            body: body
        )
    }
    
    private func performWhileLoggingPerformance(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
    {
        let fileLine = interactionPerformingSettings.fileLine
        
        let loggingElementInteractionWithDependenciesPerformer = self.loggingElementInteractionWithDependenciesPerformer()
        
        let elementInteractionWithDependenciesPerformer = self.elementInteractionWithDependenciesPerformer(
            loggingElementInteractionWithDependenciesPerformer: loggingElementInteractionWithDependenciesPerformer,
            interactionPerformingSettings: interactionPerformingSettings
        )
        
        let dependencies = elementInteractionDependencies(
            interaction: interaction,
            fileLine: fileLine,
            loggingElementInteractionWithDependenciesPerformer: loggingElementInteractionWithDependenciesPerformer
        )
        
        return elementInteractionWithDependenciesPerformer.perform(
            interaction: interaction.with(dependencies: dependencies),
            fileLine: fileLine
        )
    }
    
    private func loggingElementInteractionWithDependenciesPerformer() -> LoggingElementInteractionWithDependenciesPerformer {
        return LoggingElementInteractionWithDependenciesPerformer(
            nestedInteractionPerformer: PerformingElementInteractionWithDependenciesPerformer(),
            stepLogger: stepLogger,
            screenshotAttachmentsMaker: screenshotAttachmentsMaker,
            elementSettings: elementSettings,
            dateProvider: dateProvider
        )
    }
    
    private func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        loggingElementInteractionWithDependenciesPerformer: LoggingElementInteractionWithDependenciesPerformer)
        -> ElementInteractionDependencies
    {
        let retriableTimedInteractionState = RetriableTimedInteractionStateImpl(
            dateProvider: dateProvider,
            timeout: elementSettings.interactionTimeout,
            startDateOfInteraction: dateProvider.currentDate()
        )
        
        return elementInteractionDependenciesFactory.elementInteractionDependencies(
            interaction: interaction,
            fileLine: fileLine,
            elementInteractionWithDependenciesPerformer: loggingElementInteractionWithDependenciesPerformer,
            retriableTimedInteractionState: retriableTimedInteractionState,
            elementSettings: elementSettings
        )
    }
    
    private func elementInteractionWithDependenciesPerformer(
        loggingElementInteractionWithDependenciesPerformer: LoggingElementInteractionWithDependenciesPerformer,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> ElementInteractionWithDependenciesPerformer
    {
        if interactionPerformingSettings.failTest {
            return FailureHandlingElementInteractionWithDependenciesPerformer(
                nestedInteractionPerformer: loggingElementInteractionWithDependenciesPerformer,
                testFailureRecorder: testFailureRecorder
            )
        } else {
            return loggingElementInteractionWithDependenciesPerformer
        }
    }
}
