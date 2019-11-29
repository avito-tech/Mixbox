import Foundation
import MixboxUiTestsFoundation

public final class WaitingForQuiescenceTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "WaitingForQuiescenceTestsView"
    
    public var button: ButtonElement {
        return element("button") { element in
            element.id == "button"
        }
    }
}
