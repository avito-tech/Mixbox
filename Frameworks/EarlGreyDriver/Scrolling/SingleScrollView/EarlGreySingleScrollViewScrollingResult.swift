import EarlGrey

enum EarlGreySingleScrollViewScrollingResult {
    case interactionIsDone(EarlGreyDisambiguatedInteractionResult<GREYInteraction>)
    case shouldSkipThisScrollView
    case foundElementAfterScrolling
}
