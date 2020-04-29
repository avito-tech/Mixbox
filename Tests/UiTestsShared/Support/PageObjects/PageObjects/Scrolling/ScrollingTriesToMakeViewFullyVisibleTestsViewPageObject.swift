import MixboxUiTestsFoundation
import TestsIpc

public final class ScrollingTriesToMakeViewFullyVisibleTestsViewPageObject:
    BasePageObjectWithDefaultInitializer,
    OpenableScreen
{
    public let viewName = "ScrollingTriesToMakeViewFullyVisibleTestsView"
    
    public var button: TapIndicatorButtonElement {
        return byId("button")
    }
}
