import MixboxUiTestsFoundation

protocol ElementResolver {
    func resolveElement() -> ResolvedElementQuery
}

final class ElementResolverImpl: ElementResolver {
    private let elementFinder: ElementFinder
    private let elementSettings: ElementSettings
    
    init(
        elementFinder: ElementFinder,
        elementSettings: ElementSettings)
    {
        self.elementFinder = elementFinder
        self.elementSettings = elementSettings
    }
    
    func resolveElement() -> ResolvedElementQuery {
        let elementQuery = elementFinder.query(
            elementMatcher: elementSettings.matcher && IsNotDefinitelyHiddenMatcher(),
            waitForExistence: false
        )
        
        return elementQuery.resolveElement(interactionMode: elementSettings.interactionMode)
    }
}
