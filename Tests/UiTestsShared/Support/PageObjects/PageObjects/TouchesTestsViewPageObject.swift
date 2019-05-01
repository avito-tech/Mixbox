import MixboxUiTestsFoundation

public final class TouchesTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "TouchesTestsView"
    
    public var targetView: TouchesTestsViewTargetViewElement {
        return element("targetView") { element in
            element.id == "targetView"
        }
    }
}

public final class TouchesTestsViewTargetViewElement:
    BaseElementWithDefaultInitializer,
    ElementWithUi
{
    public var centerToWindow: CGPoint? {
        return value(valueTitle: "centerToWindow") { (snapshot: ElementSnapshot) -> CGPoint? in
            snapshot.customValue(key: "centerToWindow")
        } ?? nil
    }
}
