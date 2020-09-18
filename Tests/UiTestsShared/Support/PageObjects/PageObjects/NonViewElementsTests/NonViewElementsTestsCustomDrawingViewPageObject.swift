import Foundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

public final class NonViewElementsTestsCustomDrawingViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "NonViewElementsTestsCustomDrawingView"
    
    public var element0: ViewElement {
        return byId("element0")
    }
    
    public var element1: ViewElement {
        return byId("element1")
    }
    
    public var element2: ViewElement {
        return byId("element2")
    }
}
