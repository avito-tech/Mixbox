final class SwipeActionCanBeRunSubsequentlyTests: BaseActionTestCase {
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
}
