final class SwipeActionTests: BaseActionTestCase {
    // MARK: - Waits
    
    func test_swipeUp_waitsElementToAppear() {
        checkActionWaitsElementToAppear(
            actionSpecification: ActionSpecifications.swipeUp
        )
    }
    
    func test_swipeUp_waitsUntilElementIsNotDuplicated() {
        checkActionWaitsUntilElementIsNotDuplicated(
            actionSpecification: ActionSpecifications.swipeUp
        )
    }
    
    // MARK: - Subsequent actions
    
    func test_swipeUp_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeUp,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeDown_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeDown,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeLeft_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeLeft,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeRight_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeRight,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    // TODO: Fix
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
    
    // TODO: Fix
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheTopOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            top: [ActionSpecifications.swipeUp]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeDown,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    // TODO: Fix
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheBottomOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            bottom: [ActionSpecifications.swipeUp]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: ActionSpecifications.swipeDown,
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
