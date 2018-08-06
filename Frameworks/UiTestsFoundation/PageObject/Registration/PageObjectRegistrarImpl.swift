public final class PageObjectRegistrarImpl: PageObjectRegistrar {
    private let pageObjectDependenciesFactory: PageObjectDependenciesFactory
    
    public init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectDependenciesFactory = pageObjectDependenciesFactory
    }
    
    public func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
    {
        return initializer(pageObjectDependenciesFactory)
    }
}
