import MixboxUiTestsFoundation
import TestsIpc

public final class ScreenshotTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "ScreenshotTestsView"
    
    public func view(index: Int) -> ViewElement {
        let id = ScreenshotTestsConstants.viewId(index: index)
        return element(id) { element in element.id == id }
    }
}
