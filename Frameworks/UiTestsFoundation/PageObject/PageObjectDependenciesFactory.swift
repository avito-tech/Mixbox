// TODO: Remove
public protocol PageObjectDependenciesFactory: class {
    func pageObjectElementCoreFactory() -> PageObjectElementCoreFactory
    func matcherBuilder() -> ElementMatcherBuilder
    var elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider { get }
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
    
    func pageObjectElementCoreFactory() -> PageObjectElementCoreFactory {
        return pageObjectDependenciesFactory.pageObjectElementCoreFactory()
    }
    
    func matcherBulder() -> ElementMatcherBuilder {
        return pageObjectDependenciesFactory.matcherBuilder()
    }
}
