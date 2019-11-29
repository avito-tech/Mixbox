import MixboxUiTestsFoundation

public final class ChecksTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "ChecksTestsView"
    
    public var checkText0: LabelElement {
        return label("checkText0")
    }
    
    public var checkText1: LabelElement {
        return label("checkText1")
    }
    
    public var isNotDisplayed0: LabelElement {
        return label("isNotDisplayed0")
    }
    
    public var isDisplayed0: LabelElement {
        return label("isDisplayed0")
    }
    
    public var hasValue0: LabelElement {
        return label("hasValue0")
    }
    
    public var hasLabel0: LabelElement {
        return label("hasLabel0")
    }
    
    public var hasLabel1: LabelElement {
        return label("hasLabel1")
    }
    
    public var hasLabel2: LabelElement {
        return label("hasLabel2")
    }
    
    public var isNotDisplayed1: LabelElement {
        return label("isNotDisplayed1")
    }
    
    public var expandButton: ButtonElement {
        return button("expandButton")
    }
    
    public var collapseButton: ButtonElement {
        return button("collapseButton")
    }
    
    public var isEnabled0: ButtonElement {
        return button("isEnabled0")
    }
    
    public var isDisabled0: ButtonElement {
        return button("isDisabled0")
    }
    
    public var expandingLabel: LabelElement {
        return label("expandingLabel")
    }
    
    public var duplicated_but_one_is_hidden: LabelElement {
        return label("duplicated_but_one_is_hidden")
    }
    
    public var duplicated_and_both_are_visible: LabelElement {
        return label("duplicated_and_both_are_visible")
    }
    
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
}
