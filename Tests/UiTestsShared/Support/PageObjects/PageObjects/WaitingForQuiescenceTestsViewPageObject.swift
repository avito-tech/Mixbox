import Foundation
import MixboxUiTestsFoundation

public final class WaitingForQuiescenceTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "WaitingForQuiescenceTestsView"
    
    public func button(_ id: String) -> ButtonElement {
        return byId(id)
    }
    public var centeredLineViewControllerButton: ButtonElement {
        return byId("centeredLineViewControllerButton")
    }
}
