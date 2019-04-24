import MixboxUiTestsFoundation

// TODO: Rewrite all tests that use copypasted code. CMD+SHIFT+O "func label", etc.
final class GenericPageObject: BasePageObjectWithDefaultInitializer {
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button '\(id)'") { element in element.id == id }
    }
    
    func view(_ id: String) -> ViewElement {
        return element("view '\(id)'") { element in element.id == id }
    }
    
    func input(_ id: String) -> InputElement {
        return element("input \(id)") { element in element.id == id }
    }
}
