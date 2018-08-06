import EarlGrey
import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class EarlGreyPageObjectElementUtils: AlmightyElementUtils {
    private let elementSettings: ElementSettings
    private let interactionPerformerFactory: InteractionPerformerFactory
    private let interactionFactory: InteractionFactory
    
    init(
        elementSettings: ElementSettings,
        interactionPerformerFactory: InteractionPerformerFactory,
        interactionFactory: InteractionFactory)
    {
        self.elementSettings = elementSettings
        self.interactionPerformerFactory = interactionPerformerFactory
        self.interactionFactory = interactionFactory
    }
    
    // MARK: - AlmightyElementUtils
    
    func with(settings: ElementSettings) -> AlmightyElementUtils {
        return EarlGreyPageObjectElementUtils(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory
        )
    }
    
    func takeSnapshot(utilsSettings: UtilsSettings) -> UIImage? {
        assert(false, "not implemented")
        return nil
    }
}
