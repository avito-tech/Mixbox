import MixboxUiTestsFoundation

public final class SetTextActionWaitsForElementToGainFocusTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "SetTextActionWaitsForElementToGainFocusTestsView"
    
    public var controlWithNestedTextView: InputElement {
        return element("controlWithNestedTextView") { element in
            element.id == "controlWithNestedTextView"
        }
    }
    
    public var textView: InputElement {
        return element("textView") { element in
            element.id == "textView"
        }
    }
}
