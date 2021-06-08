import MixboxIpcCommon

public protocol ElementVisibilityChecker: AnyObject {
    func checkVisibility(
        snapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
    
    func checkVisibility(
        elementUniqueIdentifier: String,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
}
