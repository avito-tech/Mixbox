import MixboxFoundation

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
    
    public func elementImpl<T: ElementWithDefaultInitializer>(
        name: String,
        fileLine: FileLine,
        function: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        let pageObjectElement = self.pageObjectElement(
            name: name,
            fileLine: fileLine,
            function: function,
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
        name: String,
        fileLine: FileLine,
        function: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> PageObjectElement
    {
        return pageObjectElementFactory.pageObjectElement(
            settings: ElementSettings(
                elementName: name,
                fileLine: fileLine,
                function: function,
                matcher: matcherBuilder(elementMatcherBuilder),
                searchMode: searchMode ?? .default,
                interactionTimeout: nil,
                interactionMode: interactionMode ?? .default
            )
        )
    }
}
