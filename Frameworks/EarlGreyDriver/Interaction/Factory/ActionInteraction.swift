import EarlGrey
import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class ActionInteraction: EarlGreyInteraction {
    let description: InteractionDescription
    let elementMatcher: GREYMatcher
    
    private let action: GREYAction
    private var wasSuccessful = false
    
    init(
        settings: ResolvedInteractionSettings,
        elementMatcher: GREYMatcher,
        action: GREYAction)
    {
        self.description = InteractionDescription(
            type: .action,
            settings: settings
        )
        self.elementMatcher = elementMatcher
        self.action = action
    }
    
    func perform() -> InteractionResult {
        if wasSuccessful {
            return .failure(
                InteractionFailureMaker.interactionFailure(
                    message: "Attempted to run successful action twice"
                )
            )
        }
        
        let greyInteraction = EarlGrey.select(
            elementWithMatcher: elementMatcher
        )
        
        var earlGreyError: NSError?
        _ = greyInteraction.perform(action, error: &earlGreyError)
        
        if let earlGreyError = earlGreyError {
            return .failure(
                InteractionFailureMaker.interactionFailure(
                    earlGreyError: earlGreyError
                )
            )
        } else {
            wasSuccessful = true
            return .success
        }
    }
}
