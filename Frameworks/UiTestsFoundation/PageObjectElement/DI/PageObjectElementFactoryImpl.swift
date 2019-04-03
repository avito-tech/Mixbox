import MixboxTestsFoundation
import MixboxReporting

public final class PageObjectElementFactoryImpl: PageObjectElementFactory {
    // MARK: - Private properties
    
    private let testFailureRecorder: TestFailureRecorder
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    private let dateProvider: DateProvider
    
    // TODO: This is a kludge, usage of closure is dumb here.
    private let elementInteractionDependenciesFactory: (ElementSettings) -> ElementInteractionDependenciesFactory
    
    // MARK: - Init
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: @escaping (ElementSettings) -> ElementInteractionDependenciesFactory)
    {
        self.testFailureRecorder = testFailureRecorder
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
    }
    
    // MARK: - PageObjectElementFactory
    
    public func pageObjectElement(
        settings elementSettings: ElementSettings)
        -> PageObjectElement
    {
        return PageObjectElementImpl(
            settings: elementSettings,
            interactionPerformer: PageObjectElementInteractionPerformerImpl(
                testFailureRecorder: testFailureRecorder,
                screenshotAttachmentsMaker: screenshotAttachmentsMaker,
                stepLogger: stepLogger,
                dateProvider: dateProvider,
                elementInteractionDependenciesFactory: elementInteractionDependenciesFactory(elementSettings),
                elementSettings: elementSettings
            )
        )
    }
}
