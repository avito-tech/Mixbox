import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class SecondScreen: BasePageObjectWithDefaultInitializer {
    public var otherLabel: LabelElement {
        return element("other label") { element in
            element.id == "otherLabel"
        }
    }
}
