import MixboxUiTestsFoundation

final class SecondScreen: BasePageObjectWithDefaultInitializer {
    var otherLabel: LabelElement {
        return element("other label") { element in
            element.id == "otherLabel"
        }
    }
}
