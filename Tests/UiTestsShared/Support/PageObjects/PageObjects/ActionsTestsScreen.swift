import MixboxUiTestsFoundation

final class ActionsTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    let viewName = "ActionsTestsView"
    
    var info: LabelElement {
        return element("info") { element in element.id == "info" }
    }
    
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button \(id)") { element in element.id == id }
    }
    
    func input(_ id: String) -> InputElement {
        return element("input \(id)") { element in element.id == id }
    }
}
