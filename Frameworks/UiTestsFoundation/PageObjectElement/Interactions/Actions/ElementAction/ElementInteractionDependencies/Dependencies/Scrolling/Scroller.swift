import MixboxIpcCommon
import Foundation
import UIKit

public protocol Scroller: class {
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
}
