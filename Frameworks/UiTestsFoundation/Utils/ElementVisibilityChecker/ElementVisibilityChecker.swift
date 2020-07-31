import MixboxIpcCommon

public protocol ElementVisibilityChecker: class {
    func checkVisibility(
        snapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
        throws
        -> ElementVisibilityCheckerResult
    
    func percentageOfVisibleArea(
        elementUniqueIdentifier: String,
        useHundredPercentAccuracy: Bool)
        throws
        -> CGFloat
}
