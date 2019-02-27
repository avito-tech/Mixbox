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
        _ name: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        let almightyElement = self.almightyElement(
            name: name,
            matcherBuilder: matcherBuilder
        )
        return T(implementation: almightyElement)
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
    
    private func almightyElement(
        name: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> AlmightyElement
    {
        return pageObjectElementFactory.pageObjectElement(
            settings: ElementSettings(
                name: name,
                matcher: matcherBuilder(elementMatcherBuilder),
                searchMode: searchMode ?? .default,
                searchTimeout: nil,
                interactionMode: interactionMode ?? .default
            )
        )
    }
}
