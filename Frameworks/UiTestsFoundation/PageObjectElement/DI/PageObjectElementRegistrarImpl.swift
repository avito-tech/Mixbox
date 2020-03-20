import MixboxFoundation

public final class PageObjectElementRegistrarImpl: PageObjectElementRegistrar {
    private let pageObjectElementCoreFactory: PageObjectElementCoreFactory
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
        self.pageObjectElementCoreFactory = pageObjectElementDependenciesFactory.pageObjectElementCoreFactory()
        self.elementMatcherBuilder = pageObjectElementDependenciesFactory.matcherBulder()
        self.scrollMode = scrollMode
        self.interactionMode = interactionMode
    }
    
    // MARK: - PageObjectElementRegistrar
    
    public func pageObjectElementCore(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> PageObjectElementCore
    {
        return pageObjectElementCoreFactory.pageObjectElementCore(
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
}
