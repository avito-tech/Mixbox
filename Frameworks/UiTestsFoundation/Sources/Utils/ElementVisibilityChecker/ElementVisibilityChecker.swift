import MixboxIpcCommon

public protocol ElementVisibilityChecker: class {
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
