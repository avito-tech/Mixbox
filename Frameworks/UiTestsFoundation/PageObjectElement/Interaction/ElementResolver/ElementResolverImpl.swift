public final class ElementResolverImpl: ElementResolver {
    private let elementFinder: ElementFinder
    private let elementSettings: ElementSettings
    
    public init(
        elementFinder: ElementFinder,
        elementSettings: ElementSettings)
    {
        self.elementFinder = elementFinder
        self.elementSettings = elementSettings
    }
    
    public func resolveElement() -> ResolvedElementQuery {
        let elementQuery = elementFinder.query(
            elementMatcher: elementSettings.matcher && IsNotDefinitelyHiddenMatcher(),
            waitForExistence: false
        )
        
        return elementQuery.resolveElement(interactionMode: elementSettings.interactionMode)
    }
}
