import MixboxUiTestsFoundation
import MixboxTestsFoundation

extension BasePageObject {
    public func byId<T: ElementWithDefaultInitializer>(
        _ id: String)
        -> T
    {
        return element(id) { element in
            element.id == id
        }
    }
}
