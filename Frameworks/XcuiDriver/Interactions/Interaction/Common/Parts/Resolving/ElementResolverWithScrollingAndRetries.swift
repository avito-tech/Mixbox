import MixboxUiTestsFoundation

protocol ElementResolverWithScrollingAndRetries {
    func resolveElementWithRetries(
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> ResolvedElementQuery
}
