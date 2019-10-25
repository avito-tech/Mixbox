import MixboxTestsFoundation
import MixboxFoundation

public final class PageObjectElementFactoryImpl: PageObjectElementFactory {
    // MARK: - Private properties
    
    private let testFailureRecorder: TestFailureRecorder
    private let screenshotAttachmentsMaker: ScreenshotAttachmentsMaker
    private let stepLogger: StepLogger
    private let dateProvider: DateProvider
    
    // TODO: This is a kludge, usage of closure is dumb here.
    private let elementInteractionDependenciesFactory: (ElementSettings) -> ElementInteractionDependenciesFactory
    
    private let signpostActivityLogger: SignpostActivityLogger
    
    // MARK: - Init
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        screenshotAttachmentsMaker: ScreenshotAttachmentsMaker,
        stepLogger: StepLogger,
        dateProvider: DateProvider,
        elementInteractionDependenciesFactory: @escaping (ElementSettings) -> ElementInteractionDependenciesFactory,
        signpostActivityLogger: SignpostActivityLogger)
    {
        self.testFailureRecorder = testFailureRecorder
        self.screenshotAttachmentsMaker = screenshotAttachmentsMaker
        self.stepLogger = stepLogger
        self.dateProvider = dateProvider
        self.elementInteractionDependenciesFactory = elementInteractionDependenciesFactory
        self.signpostActivityLogger = signpostActivityLogger
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
                elementSettings: elementSettings,
                signpostActivityLogger: signpostActivityLogger
            )
        )
    }
}
