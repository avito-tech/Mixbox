import MixboxUiTestsFoundation
import MixboxTestsFoundation

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
                screenshotAttachmentsMaker: xcuiBasedTestsDependenciesFactory.screenshotAttachmentsMaker,
                stepLogger: xcuiBasedTestsDependenciesFactory.stepLogger,
                dateProvider: xcuiBasedTestsDependenciesFactory.dateProvider,
                elementInteractionDependenciesFactory: XcuiElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    xcuiBasedTestsDependenciesFactory: xcuiBasedTestsDependenciesFactory
                ),
                elementSettings: elementSettings
            )
        )
    }
}
