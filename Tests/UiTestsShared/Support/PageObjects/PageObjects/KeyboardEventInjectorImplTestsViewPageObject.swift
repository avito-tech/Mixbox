import Foundation
import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class KeyboardEventInjectorImplTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "KeyboardEventInjectorImplTestsView"
    
    public var textView: InputElement {
        return element("textView") { element in
            element.id == "textView"
        }
    }
}
