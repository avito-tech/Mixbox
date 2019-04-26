import MixboxUiTestsFoundation

final class SetTextActionWaitsElementTests: BaseActionTestCase {
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
        return ActionSpecifications.setText(
            text: "Text that is set",
            inputMethod: .paste
        )
    }
}
