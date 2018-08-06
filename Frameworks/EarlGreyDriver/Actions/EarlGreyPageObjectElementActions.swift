import EarlGrey
import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class EarlGreyPageObjectElementActions: AlmightyElementActions {
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
    
    private func perform(
        action: GREYAction,
        actionSettings: ActionSettings)
    {
        let interaction = interactionFactory.interaction(
            settings: ResolvedInteractionSettings(
                interactionSettings: actionSettings,
                elementSettings: elementSettings
            ),
            elementMatcher: elementSettings.matcher,
            action: action
        )
        
        let interactionPerformer = interactionPerformerFactory.performerForInteraction(
            isCheckForNotDisplayed: false,
            shouldReportResultToObserver: true
        )
        
        interactionPerformer.performInteraction(interaction: interaction)
    }
    
    // MARK: - AlmightyElementActions
    
    func with(settings: ElementSettings) -> AlmightyElementActions {
        return EarlGreyPageObjectElementActions(
            elementSettings: settings,
            interactionPerformerFactory: interactionPerformerFactory,
            interactionFactory: interactionFactory
        )
    }
    
    func tap(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        perform(
            action: grey_tap(),
            actionSettings: actionSettings
        )
    }
    
    func press(
        duration: Double,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        perform(
            action: grey_longPressWithDuration(duration),
            actionSettings: actionSettings
        )
    }
    
    func typeText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        perform(
            action: grey_typeText(text),
            actionSettings: actionSettings
        )
    }
    
    func pasteText(
        text: String,
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        // Не доделано для EarlGrey
    }
    
    func cutText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        // Не доделано для EarlGrey
    }
    
    func clearText(
        normalizedCoordinate: CGPoint?,
        absoluteOffset: CGVector?,
        actionSettings: ActionSettings)
    {
        perform(
            action: grey_clearText(),
            actionSettings: actionSettings
        )
    }
    
    func swipe(
        direction: SwipeDirection,
        actionSettings: ActionSettings)
    {
        let greyDirection: GREYDirection
        switch direction {
        case .left:
            greyDirection = .left
        case .right:
            greyDirection = .right
        case .up:
            greyDirection = .up
        case .down:
            greyDirection = .down
        }
        perform(
            action: grey_swipeFastInDirection(greyDirection),
            actionSettings: actionSettings
        )
    }
}
