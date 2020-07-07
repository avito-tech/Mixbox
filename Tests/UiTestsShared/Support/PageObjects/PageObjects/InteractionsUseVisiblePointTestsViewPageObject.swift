import Foundation
import MixboxUiTestsFoundation

public final class InteractionsUseVisiblePointTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "InteractionsUseVisiblePointTestsView"
    
    public var button: TapIndicatorButtonElement {
        return byId("button")
    }
}
