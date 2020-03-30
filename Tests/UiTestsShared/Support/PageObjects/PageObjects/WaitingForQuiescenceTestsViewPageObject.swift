import Foundation
import MixboxUiTestsFoundation

public final class WaitingForQuiescenceTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "WaitingForQuiescenceTestsView"
    
    public var tapIndicatorButton: ButtonElement {
        return byId("tapIndicatorButton")
    }
    
    public var pushButton_animated: ButtonElement {
        return byId("pushButton_animated")
    }
    
    public var pushButton_notAnimated: ButtonElement {
        return byId("pushButton_animated")
    }
    
    public var presentButton_animated: ButtonElement {
        return byId("presentButton_animated")
    }
    
    public var presentButton_notAnimated: ButtonElement {
        return byId("presentButton_notAnimated")
    }
    
    public var centeredLineViewControllerButton: ButtonElement {
        return byId("centeredLineViewControllerButton")
    }
}
