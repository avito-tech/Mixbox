import MixboxIpcCommon
import UIKit

// TODO: This particular interface should not exists or at least it should not duplicate other interfaces.
// However, we will need something like that to implement actions (ElementAction).
//
// It is a temporary workaround to pause current refactoring.
// Should be refactored further during implementation of Gray Box tests.
public protocol SnapshotForInteractionResolver: class {
    func resolve(
        arguments: SnapshotForInteractionResolverArguments,
        completion: @escaping (SnapshotForInteractionResolverResult) -> (InteractionResult))
        throws
        -> InteractionResult
}

extension SnapshotForInteractionResolver {
    // Request ElementSnapshot
    public func resolve(
        overridenPercentageOfVisibleArea: CGFloat? = nil,
        completion: @escaping (_ snapshot: ElementSnapshot) -> (InteractionResult))
        throws
        -> InteractionResult
    {
        return try resolve(
            arguments: SnapshotForInteractionResolverArguments(
                overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
                interactionCoordinates: nil
            ),
            completion: { result in
                completion(result.elementSnapshot)
            }
        )
    }
    
    // Request ElementSnapshot with the most suitable point for given InteractionCoordinates
    public func resolve(
        overridenPercentageOfVisibleArea: CGFloat? = nil,
        interactionCoordinates: InteractionCoordinates,
        completion: @escaping (_ snapshot: ElementSnapshot, _ visiblePoint: CGPoint) -> (InteractionResult))
        throws
        -> InteractionResult
    {
        return try resolve(
            arguments: SnapshotForInteractionResolverArguments(
                overridenPercentageOfVisibleArea: overridenPercentageOfVisibleArea,
                interactionCoordinates: interactionCoordinates
            ),
            completion: { result in
                completion(
                    result.elementSnapshot,
                    result.visiblePoint
                        // Fallback: (TODO: Replace silent error with some kind of assertion failure)
                        ?? interactionCoordinates.interactionCoordinatesOnScreen(elementSnapshot: result.elementSnapshot)
                )
            }
        )
    }
}
