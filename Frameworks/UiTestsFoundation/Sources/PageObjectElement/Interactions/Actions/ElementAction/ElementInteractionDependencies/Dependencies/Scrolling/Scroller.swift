import MixboxIpcCommon
import UIKit

public protocol Scroller: AnyObject {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery,
        interactionCoordinates: InteractionCoordinates?)
        -> ScrollingResult
}
