import MixboxUiTestsFoundation

final class ClearTextActionTests: BaseActionTestCase {
    func test_action_canBeRunSubsequentlyWithSameResult() {
        checkActionCanBeRunSubsequentlyWithSameResult(
            actionSpecification: actionSpecification,
            resetViewsForCurrentActionSpecification: true
        )
    }
    
    func test_action_waitsElementToAppear() {
        checkActionWaitsElementToAppear(
            actionSpecification: actionSpecification
        )
    }
    
    func test_action_waitsUntilElementIsNotDuplicated() {
        checkActionWaitsUntilElementIsNotDuplicated(
            actionSpecification: actionSpecification
        )
    }
    
    private var actionSpecification: ActionSpecification<InputElement> {
        return clearTextActionSpecification
    }
}
