final class SwipeActionTests: BaseActionTestCase {
    // MARK: - Waits
    
    func test_swipeUp_waitsElementToAppear() {
        checkActionWaitsElementToAppear(
            actionSpecification: swipeUpActionSpecification
        )
    }
    
    func test_swipeUp_waitsUntilElementIsNotDuplicated() {
        checkActionWaitsUntilElementIsNotDuplicated(
            actionSpecification: swipeUpActionSpecification
        )
    }
    
    // MARK: - Subsequent actions
    
    func test_swipeUp_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeUpActionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeDown_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeDownActionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeLeft_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeLeftActionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_swipeRight_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeRightActionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    // TODO: Fix
    func disabled_test_swipeDown_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheBottomOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            bottom: [swipeDownActionSpecification]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeDownActionSpecification,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    func disabled_test_swipeDown_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheTopOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            top: [swipeDownActionSpecification]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeDownActionSpecification,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    // TODO: Fix
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheTopOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            top: [swipeUpActionSpecification]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeDownActionSpecification,
            resetViewsForCurrentActionSpecification: false
        )
    }
    
    // TODO: Fix
    func disabled_test_swipeUp_canBeRunSubsequentlyWithSameResult_ifViewIsAtTheBottomOfTheScreen() {
        setLotsOfViewsWithoutInfo(
            bottom: [swipeUpActionSpecification]
        )
        
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: swipeDownActionSpecification,
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
                allActionSpecifications
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
