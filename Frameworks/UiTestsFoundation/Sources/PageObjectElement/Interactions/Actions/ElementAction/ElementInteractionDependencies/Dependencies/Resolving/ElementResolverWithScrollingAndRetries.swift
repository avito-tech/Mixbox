public protocol ElementResolverWithScrollingAndRetries: AnyObject {
    func resolveElementWithRetries(
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        throws
        -> ResolvedElementQuery
}
