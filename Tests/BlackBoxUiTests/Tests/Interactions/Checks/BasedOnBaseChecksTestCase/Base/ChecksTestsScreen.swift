import MixboxUiTestsFoundation

final class ChecksTestsScreen: BasePageObjectWithDefaultInitializer {
    private func label(_ id: String) -> LabelElement {
        let element: LabelElement = self.element(id) { element in element.id == id }
        return element.withoutTimeout
    }
    
    private func button(_ id: String) -> ButtonElement {
        let element: ButtonElement = self.element(id) { element in element.id == id }
        return element.withoutTimeout
    }
    
    private func view(_ id: String) -> ViewElement {
        let element: ViewElement = self.element(id) { element in element.id == id }
        return element.withoutTimeout
    }
    
    var checkText0: LabelElement {
        return label("checkText0")
    }
    
    var checkText1: LabelElement {
        return label("checkText1")
    }
    
    var isNotDisplayed0: LabelElement {
        return label("isNotDisplayed0")
    }
    
    var isDisplayed0: LabelElement {
        return label("isDisplayed0")
    }
    
    var hasValue0: LabelElement {
        return label("hasValue0")
    }
    
    var isNotDisplayed1: LabelElement {
        return label("isNotDisplayed1")
    }
    
    var expandButton: ButtonElement {
        return button("expandButton")
    }
    
    var collapseButton: ButtonElement {
        return button("collapseButton")
    }
    
    var isEnabled0: ButtonElement {
        return button("isEnabled0")
    }
    
    var isDisabled0: ButtonElement {
        return button("isDisabled0")
    }
    
    var expandingLabel: LabelElement {
        return label("expandingLabel")
    }
    
    var duplicated_but_one_is_hidden: LabelElement {
        return label("duplicated_but_one_is_hidden")
    }
    
    var duplicated_and_both_are_visible: LabelElement {
        return label("duplicated_and_both_are_visible")
    }
    
    func waitUntilUiIsLoaded() {
        let id = "ChecksTestsView"
        let view: ViewElement = element(id) { element in element.id == id }
        view.assertIsDisplayed()
    }
}
