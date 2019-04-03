import MixboxFoundation
import MixboxReporting
import MixboxTestsFoundation

public final class PageObjectElementInteractionPerformerImpl: PageObjectElementInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementSettings: ElementSettings
    private let testFailureRecorder: TestFailureRecorder
    private let dateProvider: DateProvider
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementSettings: ElementSettings)
    {
        self.testFailureRecorder = testFailureRecorder
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementSettings = elementSettings
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
    }
    
    public func perform(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
    {
        let fileLine = interactionPerformingSettings.fileLine
        
        let loggingElementInteractionWithDependenciesPerformer = LoggingElementInteractionWithDependenciesPerformer(
            nestedInteractionPerformer: PerformingElementInteractionWithDependenciesPerformer(),
            stepLogger: stepLogger,
            screenshotAttachmentsMaker: screenshotAttachmentsMaker,
            elementSettings: elementSettings
        )
        
        let elementInteractionWithDependenciesPerformer: ElementInteractionWithDependenciesPerformer
        
        if interactionPerformingSettings.failTest {
            elementInteractionWithDependenciesPerformer = FailureHandlingElementInteractionWithDependenciesPerformer(
                nestedInteractionPerformer: loggingElementInteractionWithDependenciesPerformer,
                testFailureRecorder: testFailureRecorder
            )
        } else {
            elementInteractionWithDependenciesPerformer = loggingElementInteractionWithDependenciesPerformer
        }
        
        let retriableTimedInteractionState = RetriableTimedInteractionStateImpl(
            dateProvider: dateProvider,
            timeout: elementSettings.searchTimeout,
            startDateOfInteraction: dateProvider.currentDate()
        )
        
        let dependencies = elementInteractionDependenciesFactory.elementInteractionDependencies(
            interaction: interaction,
            fileLine: fileLine,
            elementInteractionWithDependenciesPerformer: loggingElementInteractionWithDependenciesPerformer,
            retriableTimedInteractionState: retriableTimedInteractionState,
            elementSettings: elementSettings
        )
        
        return elementInteractionWithDependenciesPerformer.perform(
            interaction: interaction.with(dependencies: dependencies),
            fileLine: fileLine
        )
    }
    
    public func with(settings: ElementSettings) -> PageObjectElementInteractionPerformer {
        return PageObjectElementInteractionPerformerImpl(
            testFailureRecorder: testFailureRecorder,
            screenshotAttachmentsMaker: screenshotAttachmentsMaker,
            stepLogger: stepLogger,
            dateProvider: dateProvider,
            elementInteractionDependenciesFactory: elementInteractionDependenciesFactory,
            elementSettings: settings
        )
    }
}
