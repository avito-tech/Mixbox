import MixboxUiTestsFoundation

final class ScrollingInteractionPerformer: InteractionPerformer {
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
            if firstTryInteractionResult.wasSuccessful {
                return firstTryInteractionResult
            } else {
                // Element may be still visible
                
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
