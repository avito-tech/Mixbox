import MixboxFoundation
import MixboxTestsFoundation

public final class PageObjectElementInteractionPerformerImpl: PageObjectElementInteractionPerformer {
    private let elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory
    private let elementSettings: ElementSettings
    private let testFailureRecorder: TestFailureRecorder
    private let dateProvider: DateProvider
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    private let performanceLogger: PerformanceLogger
    private let interactionFailureDebugger: InteractionFailureDebugger
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: ElementInteractionDependenciesFactory,
        elementSettings: ElementSettings,
        performanceLogger: PerformanceLogger,
        interactionFailureDebugger: InteractionFailureDebugger)
    {
        self.testFailureRecorder = testFailureRecorder
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.elementSettings = elementSettings
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
        self.performanceLogger = performanceLogger
        self.interactionFailureDebugger = interactionFailureDebugger
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
            performanceLogger: performanceLogger,
            interactionFailureDebugger: interactionFailureDebugger
        )
    }
    
    // MARK: - Private
    
    private func logPerformance<T>(interactionType: ElementInteraction.Type, body: () -> T) -> T {
        return performanceLogger.log(
            staticName: "performing root interaction",
            dynamicName: { "\(interactionType)" },
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
            dateProvider: dateProvider
        )
    }
    
    private func elementInteractionDependencies(
        interaction: ElementInteraction,
        fileLine: FileLine,
        loggingElementInteractionWithDependenciesPerformer: LoggingElementInteractionWithDependenciesPerformer)
        -> ElementInteractionDependencies
    {
        let interactionSettings = elementSettings.interactionSettings(interaction: interaction)
        
        let retriableTimedInteractionState = RetriableTimedInteractionStateImpl(
            dateProvider: dateProvider,
            timeout: interactionSettings.interactionTimeout,
            startDateOfInteraction: dateProvider.currentDate(),
            parent: nil
        )
        
        return elementInteractionDependenciesFactory.elementInteractionDependencies(
            interaction: interaction,
            fileLine: fileLine,
            elementInteractionWithDependenciesPerformer: loggingElementInteractionWithDependenciesPerformer,
            retriableTimedInteractionState: retriableTimedInteractionState,
            elementSettings: elementSettings,
            interactionSettings: interactionSettings
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
                testFailureRecorder: testFailureRecorder,
                interactionFailureDebugger: interactionFailureDebugger
            )
        } else {
            return loggingElementInteractionWithDependenciesPerformer
        }
    }
}
