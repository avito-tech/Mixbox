import EarlGrey

extension GREYInteraction {
    func performOnDisambiguatedInteraction(assertionWithMatcher matcher: GREYMatcher)
        -> EarlGreyDisambiguatedInteractionResult<GREYInteraction>
    {
        return performOnDisambiguatedInteraction { (error: inout NSError?) -> (GREYInteraction?) in
            // TODO: fix assertion rule. It should trigger only on global functions
            // swiftlint:disable:next assertion
            assert(matcher, error: &error)
        }
    }
    
    func performOnDisambiguatedInteraction(action: GREYAction)
        -> EarlGreyDisambiguatedInteractionResult<GREYInteraction>
    {
        return performOnDisambiguatedInteraction { (error: inout NSError?) -> (GREYInteraction?) in
            perform(action, error: &error)
        }
    }
    
    private func performOnDisambiguatedInteraction(closure: (_ error: inout NSError?) -> (GREYInteraction?))
        -> EarlGreyDisambiguatedInteractionResult<GREYInteraction>
    {
        let result: EarlGreyDisambiguatedInteractionResult<GREYInteraction>
        
        var error: NSError?
        let interaction = closure(&error)
        
        if let error = error {
            switch error.code {
            case GREYInteractionErrorCode.matchedElementIndexOutOfBoundsErrorCode.rawValue:
                result = EarlGreyDisambiguatedInteractionResult.indexOutOfBoundsError(error)
            case GREYInteractionErrorCode.elementNotFoundErrorCode.rawValue:
                result = EarlGreyDisambiguatedInteractionResult.elementNotFoundError(error)
            default:
                result = EarlGreyDisambiguatedInteractionResult.otherError(error)
            }
        } else if let interaction = interaction {
            result = EarlGreyDisambiguatedInteractionResult.success(interaction)
        } else {
            assertionFailure("error or interaction should be present, got nils")
            result = EarlGreyDisambiguatedInteractionResult.otherError(NSError())
        }
        
        return result
    }
}
