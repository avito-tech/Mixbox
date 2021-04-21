public final class ElementResolverImpl: ElementResolver {
    private let elementFinder: ElementFinder
    private let interactionSettings: InteractionSettings
    
    public init(
        elementFinder: ElementFinder,
        interactionSettings: InteractionSettings)
    {
        self.elementFinder = elementFinder
        self.interactionSettings = interactionSettings
    }
    
    public func resolveElement() throws -> ResolvedElementQuery {
        let elementQuery = elementFinder.query(
            elementMatcher: interactionSettings.matcher, // TODO: move matcher from `filteringHiddenElement` here?
            elementFunctionDeclarationLocation: interactionSettings.functionDeclarationLocation
        )
        
        return elementQuery.resolveElement(interactionMode: interactionSettings.interactionMode)
    }
}
