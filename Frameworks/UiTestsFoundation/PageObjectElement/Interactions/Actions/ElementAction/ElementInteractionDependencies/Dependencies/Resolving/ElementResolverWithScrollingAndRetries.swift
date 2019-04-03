public protocol ElementResolverWithScrollingAndRetries {
    func resolveElementWithRetries(
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> ResolvedElementQuery
}
