public protocol PageObjectDependenciesFactory: class {
    func pageObjectElementFactory() -> PageObjectElementFactory
}

public extension PageObjectDependenciesFactory {
    func pageObjectElementDependenciesFactory() -> PageObjectElementDependenciesFactory {
        return PageObjectDependenciesFactoryToPageObjectElementDependenciesFactory(
            pageObjectDependenciesFactory: self
        )
    }
}

final class PageObjectDependenciesFactoryToPageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory {
    private let pageObjectDependenciesFactory: PageObjectDependenciesFactory
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectDependenciesFactory = pageObjectDependenciesFactory
    }
    
    func pageObjectElementFactory() -> PageObjectElementFactory {
        return pageObjectDependenciesFactory.pageObjectElementFactory()
    }
}
