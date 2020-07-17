import MixboxIpcCommon

public protocol ElementVisibilityChecker: class {
    func checkVisibility(
        snapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates?)
        throws
        -> ElementVisibilityCheckerResult
    
    func percentageOfVisibleArea(
        elementUniqueIdentifier: String)
        throws
        -> CGFloat
}
