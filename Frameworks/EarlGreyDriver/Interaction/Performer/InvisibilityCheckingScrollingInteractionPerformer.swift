import MixboxUiTestsFoundation

final class InvisibilityCheckingScrollingInteractionPerformer: InteractionPerformer {
    // MARK: - Private properties
    private let earlGreyScroller: EarlGreyScroller
    
    // MARK: - Init
    init(earlGreyScroller: EarlGreyScroller) {
        self.earlGreyScroller = earlGreyScroller
    }
    
    @discardableResult
    func performInteraction(
        interaction: Interaction)
        -> InteractionResult
    {
        let firstTryInteractionResult = interaction.perform()
        
        if interaction.description.settings.shouldAutoScroll {
            if firstTryInteractionResult.wasFailed {
                // Item is visible at the moment. Check failed
                
                return firstTryInteractionResult
            } else {
                // Item is not visible at the moment. But it may become visible after scrolling
                
                // MVP:
                guard let earlGreyInteraction = interaction as? EarlGreyInteraction else {
                    return .failure(
                        InteractionFailureMaker.interactionFailure(message: "interaction is not EarlGreyInteraction")
                    )
                }
                
                earlGreyScroller.scrollToVisibleElement(
                    elementMatcher: earlGreyInteraction.elementMatcher
                )
                
                return interaction.perform()
            }
        } else {
            return firstTryInteractionResult
        }
    }
}
