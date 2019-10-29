import MixboxUiTestsFoundation
import MixboxTestsFoundation

// TODO: Share code between black-box and gray-box.
final class GrayPageObjectElementFactory: PageObjectElementFactory {
    // MARK: - Private properties
    private let grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory
    
    // MARK: - Init
    init(grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory) {
        self.grayBoxTestsDependenciesFactory = grayBoxTestsDependenciesFactory
    }
    
    // MARK: - PageObjectElementFactory
    func pageObjectElement(
        settings elementSettings: ElementSettings)
        -> PageObjectElement
    {
        return PageObjectElementImpl(
            settings: elementSettings,
            interactionPerformer: PageObjectElementInteractionPerformerImpl(
                testFailureRecorder: grayBoxTestsDependenciesFactory.testFailureRecorder,
                screenshotAttachmentsMaker: grayBoxTestsDependenciesFactory.screenshotAttachmentsMaker,
                stepLogger: grayBoxTestsDependenciesFactory.stepLogger,
                dateProvider: grayBoxTestsDependenciesFactory.dateProvider,
                elementInteractionDependenciesFactory: GrayElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    grayBoxTestsDependenciesFactory: grayBoxTestsDependenciesFactory
                ),
                elementSettings: elementSettings,
                signpostActivityLogger: grayBoxTestsDependenciesFactory.signpostActivityLogger
            )
        )
    }
}
