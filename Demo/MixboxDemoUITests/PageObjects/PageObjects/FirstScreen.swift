import MixboxUiTestsFoundation

final class FirstScreen: BasePageObjectWithDefaultInitializer {
    var label: LabelElement {
        return element("label") { element in
            element.id == "label"
        }
    }
    
    var button: ButtonElement {
        return element("button") { $0.id == "button" }
    }
}
