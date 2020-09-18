import Foundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation

public final class NonViewElementsTestsMapViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "NonViewElementsTestsMapView"

    public var pin: ViewElement {
        return element("Pin") { element in
            element.id == "pin"
        }
    }
}
