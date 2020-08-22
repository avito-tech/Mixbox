import MixboxTestsFoundation
import MixboxFoundation

public final class PageObjectElementCoreFactoryImpl: PageObjectElementCoreFactory {
    // MARK: - Private properties
    
    private let testFailureRecorder: TestFailureRecorder
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    private let dateProvider: DateProvider
    
    // TODO: This is a kludge, usage of closure is dumb here.
    private let elementInteractionDependenciesFactory: (ElementSettings) -> ElementInteractionDependenciesFactory
    
    private let performanceLogger: PerformanceLogger
    private let interactionFailureDebugger: InteractionFailureDebugger
    
    // MARK: - Init
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: @escaping (ElementSettings) -> ElementInteractionDependenciesFactory,
        performanceLogger: PerformanceLogger,
        interactionFailureDebugger: InteractionFailureDebugger)
    {
        self.testFailureRecorder = testFailureRecorder
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.performanceLogger = performanceLogger
        self.interactionFailureDebugger = interactionFailureDebugger
    }
    
    // MARK: - PageObjectElementCoreFactory
    
    public func pageObjectElementCore(
        settings elementSettings: ElementSettings)
        -> PageObjectElementCore
    {
        return PageObjectElementCoreImpl(
            settings: elementSettings,
            interactionPerformer: PageObjectElementInteractionPerformerImpl(
                testFailureRecorder: testFailureRecorder,
                screenshotAttachmentsMaker: screenshotAttachmentsMaker,
                stepLogger: stepLogger,
                dateProvider: dateProvider,
                elementInteractionDependenciesFactory: elementInteractionDependenciesFactory(elementSettings),
                elementSettings: elementSettings,
                performanceLogger: performanceLogger,
                interactionFailureDebugger: interactionFailureDebugger
            )
        )
    }
}
