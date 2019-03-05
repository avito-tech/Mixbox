import MixboxUiTestsFoundation
import XCTest
import MixboxIpcCommon

protocol Scroller {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
}
