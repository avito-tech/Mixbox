import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class FirstScreen: BasePageObjectWithDefaultInitializer {
    public var label: LabelElement {
        return element("label") { element in
            element.id == "label"
        }
    }
    
    public var button: ButtonElement {
        return element("button") { $0.id == "button" }
    }
}
