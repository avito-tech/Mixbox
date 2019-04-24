import MixboxUiTestsFoundation

protocol OpenableScreen: PageObjectElementRegistrar {
    var viewName: String { get }
}

extension OpenableScreen {
    public var view: ViewElement {
        return element(viewName) { element in element.id == viewName }
    }
    
    public func waitUntilViewIsLoaded() {
        view.assertIsDisplayed()
    }
}
