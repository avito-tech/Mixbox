import MixboxIpcCommon
import UIKit

public protocol Scroller: class {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery,
        interactionCoordinates: InteractionCoordinates?)
        -> ScrollingResult
}
