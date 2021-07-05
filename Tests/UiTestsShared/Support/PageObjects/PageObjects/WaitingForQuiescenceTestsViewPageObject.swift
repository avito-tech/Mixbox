import Foundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

public final class WaitingForQuiescenceTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "WaitingForQuiescenceTestsView"
    
    public func button(_ id: String) -> ButtonElement {
        return byId(id)
    }
    
    public func tapIndicatorButton(_ id: String) -> TapIndicatorButtonElement {
        return byId(id)
    }
    
    public var centeredLineViewControllerButton: TapIndicatorButtonElement {
        return element("centeredLineViewControllerButton") { element in
            element.id == "button" && element.isSubviewOf { element in
                element.id == "centeredLineViewControllerButton"
            }
        }
    }
    public var accessoryViewButton: ButtonElement {
        return byId("accessoryViewButton")
    }
}
