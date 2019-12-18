import MixboxFoundation

public final class PageObjectElementRegistrarImpl: PageObjectElementRegistrar {
    private let pageObjectElementFactory: PageObjectElementFactory
    private let pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory
    private let scrollMode: ScrollMode?
    private let interactionMode: InteractionMode?
    private let elementMatcherBuilder: ElementMatcherBuilder
    
    public init(
        pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory,
        scrollMode: ScrollMode? = nil,
        interactionMode: InteractionMode? = nil)
    {
        self.pageObjectElementDependenciesFactory = pageObjectElementDependenciesFactory
        self.pageObjectElementFactory = pageObjectElementDependenciesFactory.pageObjectElementFactory()
        self.elementMatcherBuilder = pageObjectElementDependenciesFactory.matcherBulder()
        self.scrollMode = scrollMode
        self.interactionMode = interactionMode
    }
    
    // MARK: - PageObjectElementRegistrar
    
    public func elementImpl<T: ElementWithDefaultInitializer>(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        let pageObjectElement = self.pageObjectElement(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcherBuilder: matcherBuilder
        )
        return T(implementation: pageObjectElement)
    }
    
    public func with(scrollMode: ScrollMode) -> PageObjectElementRegistrar {
        return PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            scrollMode: scrollMode,
            interactionMode: interactionMode
        )
    }
    
    public func with(interactionMode: InteractionMode) -> PageObjectElementRegistrar {
        return PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            scrollMode: scrollMode,
            interactionMode: interactionMode
        )
    }
    
    // MARK: - Private
    
    private func pageObjectElement(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> PageObjectElement
    {
        return pageObjectElementFactory.pageObjectElement(
            settings: ElementSettings(
                name: name,
                functionDeclarationLocation: functionDeclarationLocation,
                matcher: matcherBuilder(elementMatcherBuilder),
                scrollMode: scrollMode ?? .default,
                interactionTimeout: nil,
                interactionMode: interactionMode ?? .default
            )
        )
    }
}
