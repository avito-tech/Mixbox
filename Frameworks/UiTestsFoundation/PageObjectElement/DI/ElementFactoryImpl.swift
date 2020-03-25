import MixboxFoundation

public final class ElementFactoryImpl: ElementFactory {
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
    
    // MARK: - ElementFactory
    
    public func element<T>(
        name: String,
        factory: (PageObjectElementCore) -> T,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return factory(
            pageObjectElementCore(
                name: name,
                functionDeclarationLocation: functionDeclarationLocation,
                matcherBuilder: matcherBuilder
            )
        )
    }
    
    public func with(scrollMode: ScrollMode) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            scrollMode: scrollMode,
            interactionMode: interactionMode
        )
    }
    
    public func with(interactionMode: InteractionMode) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            scrollMode: scrollMode,
            interactionMode: interactionMode
        )
    }
    
    // MARK: - Private
    
    private func pageObjectElementCore(
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
}
