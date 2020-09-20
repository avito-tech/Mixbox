import MixboxIpcCommon
import MixboxIpc
import MixboxUiKit
import MixboxFoundation

public final class ElementVisibilityCheckerImpl: ElementVisibilityChecker {
    private let ipcClient: SynchronousIpcClient
    
    public init(ipcClient: SynchronousIpcClient) {
        self.ipcClient = ipcClient
    }
    
    // MARK: - ElementVisibilityChecker
    
    public func checkVisibility(
        snapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
    {
        if let isDefinitelyHidden = snapshot.isDefinitelyHidden.valueIfAvailable, isDefinitelyHidden {
            return definitelyHiddenResult()
        }
        
        var parentPointer = snapshot.parent
        var lastParent = snapshot.parent
        
        while let parent = parentPointer {
            lastParent = parent
            parentPointer = parent.parent
        }
        if let topSnapshotFrame = lastParent?.frameRelativeToScreen {
            if !topSnapshotFrame.intersects(snapshot.frameRelativeToScreen) {
                return definitelyHiddenResult()
            }
        }

        if snapshot.frameRelativeToScreen.mb_hasZeroArea() {
            return definitelyHiddenResult()
        }
        
        if let elementUniqueIdentifier = snapshot.uniqueIdentifier.valueIfAvailable {
            return try callIpcClient(
                elementUniqueIdentifier: elementUniqueIdentifier,
                interactionCoordinates: interactionCoordinates,
                useHundredPercentAccuracy: useHundredPercentAccuracy
            )
        } else {
            // Visibility check is not available for this element (e.g.: not a view or it is an element in
            // a third-party app / without MixboxInAppServices). Because we can't tell if the element is
            // hidden, we can say that it is visible, and it is the only case when we return this result,
            // it has to be at least one case.
            return canBeVisibleResult()
        }
    }
    
    public func checkVisibility(
        elementUniqueIdentifier: String,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
    {
        return try callIpcClient(
            elementUniqueIdentifier: elementUniqueIdentifier,
            interactionCoordinates: interactionCoordinates,
            useHundredPercentAccuracy: useHundredPercentAccuracy
        )
    }
    
    // MARK: - Private
    
    private func definitelyHiddenResult() -> ElementVisibilityCheckerResult {
        return ElementVisibilityCheckerResult(
            percentageOfVisibleArea: 0,
            visibilePointOnScreenClosestToInteractionCoordinates: nil
        )
    }
    
    private func canBeVisibleResult() -> ElementVisibilityCheckerResult {
        return ElementVisibilityCheckerResult(
            percentageOfVisibleArea: 1,
            visibilePointOnScreenClosestToInteractionCoordinates: nil
        )
    }
    
    private func callIpcClient(
        elementUniqueIdentifier: String,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
    {
        let result = try ipcClient.callOrThrow(
            method: CheckVisibilityIpcMethod(),
            arguments: CheckVisibilityIpcMethod.Arguments(
                elementUniqueIdentifier: elementUniqueIdentifier,
                interactionCoordinates: interactionCoordinates,
                useHundredPercentAccuracy: useHundredPercentAccuracy
            )
        )
        
        switch result {
        case .view(let result):
            return ElementVisibilityCheckerResult(
                percentageOfVisibleArea: result.percentageOfVisibleArea,
                visibilePointOnScreenClosestToInteractionCoordinates: result.visibilePointOnScreenClosestToInteractionCoordinates
            )
        case .nonView(let result):
            return ElementVisibilityCheckerResult(
                percentageOfVisibleArea: result.percentageOfVisibleArea,
                // TODO (non-view elements): return an information that the element is not a view instead of returnin nil here?
                visibilePointOnScreenClosestToInteractionCoordinates: nil
            )
        case .error(let error):
            throw error
        }
    }
}
