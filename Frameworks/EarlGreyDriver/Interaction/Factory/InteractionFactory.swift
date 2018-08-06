import MixboxUiTestsFoundation
import EarlGrey
import MixboxTestsFoundation

protocol InteractionFactory {
    func interaction(
        settings: ResolvedInteractionSettings,
        elementMatcher: ElementMatcher,
        action: GREYAction)
        -> Interaction
    
    func interaction(
        settings: ResolvedInteractionSettings,
        elementMatcher: ElementMatcher,
        checkMatcher: GREYMatcher,
        isCheckForNotDisplayed: Bool)
        -> Interaction
}

final class InteractionFactoryImpl: InteractionFactory {
    private let predicateNodeToEarlGreyMatcherConverter: PredicateNodeToEarlGreyMatcherConverter
    
    init(
        predicateNodeToEarlGreyMatcherConverter: PredicateNodeToEarlGreyMatcherConverter)
    {
        self.predicateNodeToEarlGreyMatcherConverter = predicateNodeToEarlGreyMatcherConverter
    }
    
    func interaction(
        settings: ResolvedInteractionSettings,
        elementMatcher: ElementMatcher,
        action: GREYAction)
        -> Interaction
    {
        // Always true for actions. Element should be visible for every supported action (tapping/typing/etc)
        let shouldAddSufficientlyVisibleMatcher = true
        
        return ActionInteraction(
            settings: settings,
            elementMatcher: patchedElementMatcher(
                elementMatcher: elementMatcher,
                shouldAddSufficientlyVisibleMatcher: shouldAddSufficientlyVisibleMatcher
            ),
            action: action
        )
    }
    
    func interaction(
        settings: ResolvedInteractionSettings,
        elementMatcher: ElementMatcher,
        checkMatcher: GREYMatcher,
        isCheckForNotDisplayed: Bool)
        -> Interaction
    {
        // We shouldn't add constraint on isDisplayed for isNotDisplayed check.
        let shouldAddSufficientlyVisibleMatcher = !isCheckForNotDisplayed
        
        // In collection views there are usually 2 cells for fade animation, one of which is not displayed.
        // In case of isNotDisplayed check there will be 2 not displayed elements, if both are not visible,
        // then it is ok.
        let ambiguityResolvingMode: CheckInteraction.AmbiguityResolvingMode = isCheckForNotDisplayed
            ? .checkAllMatchingElements
            : .failIfMultipleElementsAreMatching
        
        return CheckInteraction(
            settings: settings,
            elementMatcher: patchedElementMatcher(
                elementMatcher: elementMatcher,
                shouldAddSufficientlyVisibleMatcher: shouldAddSufficientlyVisibleMatcher
            ),
            checkMatcher: checkMatcher,
            ambiguityResolvingMode: ambiguityResolvingMode
        )
    }
    
    private func patchedElementMatcher(
        elementMatcher: ElementMatcher,
        shouldAddSufficientlyVisibleMatcher: Bool)
        -> GREYMatcher
    {
        let greyMatcher = predicateNodeToEarlGreyMatcherConverter.greyMatcher(
            predicateNode: elementMatcher.rootPredicateNode
        )
        
        if shouldAddSufficientlyVisibleMatcher {
            // To resolve ambiguities in collection view,
            // when there can be two cells with same elements (due to animations),
            // and one cell is not visible.
            return grey_allOf(
                [
                    greyMatcher,
                    grey_sufficientlyVisible()
                ]
            )
        } else {
            return greyMatcher
        }
    }
}
