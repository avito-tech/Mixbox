public protocol PageObjectDependenciesFactory: class {
    func pageObjectElementFactory() -> PageObjectElementFactory
    func matcherBuilder() -> ElementMatcherBuilder
}

public extension PageObjectDependenciesFactory {
    func pageObjectElementDependenciesFactory() -> PageObjectElementDependenciesFactory {
        return PageObjectDependenciesFactoryToPageObjectElementDependenciesFactory(
            pageObjectDependenciesFactory: self
        )
    }
}

// TODO: Remove
final class PageObjectDependenciesFactoryToPageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory {
    private let pageObjectDependenciesFactory: PageObjectDependenciesFactory
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectDependenciesFactory = pageObjectDependenciesFactory
    }
    
    func pageObjectElementFactory() -> PageObjectElementFactory {
        return pageObjectDependenciesFactory.pageObjectElementFactory()
    }
    
    func matcherBulder() -> ElementMatcherBuilder {
        return pageObjectDependenciesFactory.matcherBuilder()
    }
}
