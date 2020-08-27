import UIKit

public final class SnapshotForInteractionResolverResult {
    public let visiblePoint: CGPoint?
    public let elementSnapshot: ElementSnapshot
    
    public init(
        visiblePoint: CGPoint?,
        elementSnapshot: ElementSnapshot)
    {
        self.visiblePoint = visiblePoint
        self.elementSnapshot = elementSnapshot
    }
}
