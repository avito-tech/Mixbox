import MixboxUiTestsFoundation
import MixboxTestsFoundation

protocol OpenableScreen: class {
    var viewName: String { get }
}

extension OpenableScreen where Self: ElementFactory {
    var view: ViewElement {
        return element(viewName) { element in element.id == viewName }
    }
    
    func waitUntilViewIsLoaded() {
        view.assertIsInHierarchy()
    }
}

extension OpenableScreen where Self: DefaultElementFactoryProvider  {
    var view: ViewElement {
        return defaultElementFactory.element(viewName) { element in element.id == viewName }
    }
    
    func waitUntilViewIsLoaded() {
        view.assertIsInHierarchy()
    }
}
