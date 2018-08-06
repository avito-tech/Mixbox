import EarlGrey
import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class CheckInteraction: EarlGreyInteraction {
    let description: InteractionDescription
    let elementMatcher: GREYMatcher
    
    enum AmbiguityResolvingMode {
        case checkAllMatchingElements
        case failIfMultipleElementsAreMatching
    }
    
    private let checkMatcher: GREYMatcher
    private let ambiguityResolvingMode: AmbiguityResolvingMode
    
    init(
        settings: ResolvedInteractionSettings,
        elementMatcher: GREYMatcher,
        checkMatcher: GREYMatcher,
        ambiguityResolvingMode: AmbiguityResolvingMode)
    {
        self.description = InteractionDescription(
            type: .check,
            settings: settings
        )
        self.elementMatcher = elementMatcher
        self.checkMatcher = checkMatcher
        self.ambiguityResolvingMode = ambiguityResolvingMode
    }
    
    func perform() -> InteractionResult {
        let earlGreyError: NSError?
        
        switch ambiguityResolvingMode {
        case .checkAllMatchingElements:
            earlGreyError = performAndCheckAllMatchingElements()
        case .failIfMultipleElementsAreMatching:
            earlGreyError = performAndFailIfMultipleElementsAreMatching()
        }
        
        if let earlGreyError = earlGreyError {
            return .failure(
                InteractionFailureMaker.interactionFailure(
                    earlGreyError: earlGreyError
                )
            )
        } else {
            return .success
        }
    }

    private func performAndCheckAllMatchingElements() -> NSError? {
        var earlGreyError: NSError?
        
        EarlGreyInteractionDisambiguation.iterateEveryElement(
            ambigousInteraction: {
                EarlGrey.select(elementWithMatcher: elementMatcher)
            },
            forEach: { arguments in
                let result = arguments.disambiguatedInteraction.performOnDisambiguatedInteraction(
                    assertionWithMatcher: checkMatcher
                )
                
                if earlGreyError == nil {
                    // First error is enough
                    
                    switch result {
                    case .success, .indexOutOfBoundsError:
                        break
                    case .elementNotFoundError(let error):
                        earlGreyError = error
                    case .otherError(let error):
                        earlGreyError = error
                    }
                }
                
                return EarlGreyInteractionDisambiguation.IterationResult(result)
            }
        )
        
        return earlGreyError
    }
    
    func performAndFailIfMultipleElementsAreMatching() -> NSError? {
        var earlGreyError: NSError?
        
        // EarlGrey will failIfMultipleElementsAreMatching itself
        let interaction = EarlGrey.select(elementWithMatcher: elementMatcher)
        // TODO: fix assertion rule. It should trigger only on global functions
        // swiftlint:disable:next assertion
        interaction.assert(checkMatcher, error: &earlGreyError)
        
        return earlGreyError
    }
}
