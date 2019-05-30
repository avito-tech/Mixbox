import MixboxIpcCommon

public protocol Scroller: class {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
}
