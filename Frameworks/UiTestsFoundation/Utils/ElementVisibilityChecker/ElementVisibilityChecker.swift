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

extension ElementVisibilityChecker {
    func checkVisibility(
        snapshot: ElementSnapshot,
        interactionCoordinates: InteractionCoordinates?,
        minimalPercentageOfVisibleArea: CGFloat)
        throws
        -> ElementVisibilityCheckerResult
    {
        return try checkVisibility(
            snapshot: snapshot,
            interactionCoordinates: interactionCoordinates,
            useHundredPercentAccuracy: useHundredPercentAccuracy(
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
            )
        )
    }
    
    func percentageOfVisibleArea(
        elementUniqueIdentifier: String,
        minimalPercentageOfVisibleArea: CGFloat)
        throws
        -> CGFloat
    {
        return try percentageOfVisibleArea(
            elementUniqueIdentifier: elementUniqueIdentifier,
            useHundredPercentAccuracy: useHundredPercentAccuracy(
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
            )
        )
    }
    
    private func useHundredPercentAccuracy(minimalPercentageOfVisibleArea: CGFloat) -> Bool {
        // This code smells, because it relies on a knowledge that
        // current "grid" otimization in visibility check has accuracy of 0.02 (for large square views).
        // And if 100% visibility is requested it can return that view is visible if, for example,
        // only 99% of view is visible. To get rid of all such problems the value is even lower than 0.98:
        return minimalPercentageOfVisibleArea >= 0.95
    }
}
