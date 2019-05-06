// TODO: Fix tests
final class SwipeActionCanBeRunFromAnyPartOfScreenTests: BaseActionTestCase {
    func disabled_test_swipeDown_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheBottomOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            bottom: [ActionSpecifications.swipeDown]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeDown,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    func disabled_test_swipeDown_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheTopOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            top: [ActionSpecifications.swipeDown]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeDown,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheTopOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            top: [ActionSpecifications.swipeUp]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeUp,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheBottomOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            bottom: [ActionSpecifications.swipeUp]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeUp,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    // MARK: - Private
    
    private func setLotsOfViewsWithoutInfo(
        top: [AnyActionSpecification])
    {
        setLotsOfViewsWithoutInfo { source in
            let middle = removeDuplicates(
                specificationsToRemove: top,
                specificationsToRemoveFrom: source
            )
            
            return top + middle
        }
    }
    
    private func setLotsOfViewsWithoutInfo(
        bottom: [AnyActionSpecification])
    {
        setLotsOfViewsWithoutInfo { source in
            let middle = removeDuplicates(
                specificationsToRemove: bottom,
                specificationsToRemoveFrom: source
            )
            
            return middle + bottom
        }
    }
    
    // info will affect positions of views, so it is disabled
    private func setLotsOfViewsWithoutInfo(
        override: ([AnyActionSpecification]) -> ([AnyActionSpecification]))
    {
        setViews(
            showInfo: false,
            actionSpecifications: override(
                ActionSpecifications.all
            )
        )
    }
    
    private func removeDuplicates(
        specificationsToRemove: [AnyActionSpecification],
        specificationsToRemoveFrom: [AnyActionSpecification])
        -> [AnyActionSpecification]
    {
        return specificationsToRemoveFrom.filter { lhs in
            !specificationsToRemove.contains { rhs in
                lhs.elementId == rhs.elementId
            }
        }
    }
}
