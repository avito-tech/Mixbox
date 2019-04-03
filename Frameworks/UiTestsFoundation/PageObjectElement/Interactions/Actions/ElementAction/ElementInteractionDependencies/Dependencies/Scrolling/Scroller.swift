import MixboxIpcCommon

public protocol Scroller {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
}
