import MixboxUiTestsFoundation

final class PressActionTests: BaseActionTestCase {
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
    
    private var actionSpecification: ActionSpecification<ButtonElement> {
        return ActionSpecifications.press
    }
}
