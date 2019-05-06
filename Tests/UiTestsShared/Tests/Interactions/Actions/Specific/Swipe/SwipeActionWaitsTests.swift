final class SwipeActionTests: BaseActionTestCase {
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
}
