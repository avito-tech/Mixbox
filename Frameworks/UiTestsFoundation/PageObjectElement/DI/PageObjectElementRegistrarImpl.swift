public final class PageObjectElementRegistrarImpl: PageObjectElementRegistrar {
    private let pageObjectElementFactory: PageObjectElementFactory
    private let pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory
    private let searchMode: SearchMode?
    private let interactionMode: InteractionMode?
    private let elementMatcherBuilder: ElementMatcherBuilder
    
    public init(
        pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory,
        searchMode: SearchMode? = nil,
        interactionMode: InteractionMode? = nil)
    {
        self.pageObjectElementDependenciesFactory = pageObjectElementDependenciesFactory
        self.pageObjectElementFactory = pageObjectElementDependenciesFactory.pageObjectElementFactory()
        self.elementMatcherBuilder = pageObjectElementDependenciesFactory.matcherBulder()
        self.searchMode = searchMode
        self.interactionMode = interactionMode
    }
    
    // MARK: - PageObjectElementRegistrar
    
    public func element<T: ElementWithDefaultInitializer>(
        _ elementName: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        let pageObjectElement = self.pageObjectElement(
            elementName: elementName,
            matcherBuilder: matcherBuilder
        )
        return T(implementation: pageObjectElement)
    }
    
    public func with(searchMode: SearchMode) -> PageObjectElementRegistrar {
        return PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            searchMode: searchMode,
            interactionMode: interactionMode
        )
    }
    
    public func with(interactionMode: InteractionMode) -> PageObjectElementRegistrar {
        return PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            searchMode: searchMode,
            interactionMode: interactionMode
        )
    }
    
    // MARK: - Private
    
    private func pageObjectElement(
        elementName: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> PageObjectElement
    {
        return pageObjectElementFactory.pageObjectElement(
            settings: ElementSettings(
                elementName: elementName,
                matcher: matcherBuilder(elementMatcherBuilder),
                searchMode: searchMode ?? .default,
                interactionTimeout: nil,
                interactionMode: interactionMode ?? .default
            )
        )
    }
}
