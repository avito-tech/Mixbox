import Foundation
import UIKit

public protocol PerformerOfSpecificImplementationOfInteractionForVisibleElement: class {
    func performInteractionForVisibleElement(
        overridenPercentageOfVisibleArea: CGFloat?,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
}
