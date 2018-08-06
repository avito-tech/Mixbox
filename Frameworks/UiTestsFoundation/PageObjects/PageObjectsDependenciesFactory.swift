public protocol PageObjectsDependenciesFactory: class {
    func pageObjectElementFactory() -> PageObjectElementFactory
}

public extension PageObjectsDependenciesFactory {
    func pageObjectDependenciesFactory() -> PageObjectDependenciesFactory {
        return PageObjectsDependenciesFactoryToPageObjectDependenciesFactory(
            pageObjectsDependenciesFactory: self
        )
    }
}

final class PageObjectsDependenciesFactoryToPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let pageObjectsDependenciesFactory: PageObjectsDependenciesFactory
    
    init(pageObjectsDependenciesFactory: PageObjectsDependenciesFactory) {
        self.pageObjectsDependenciesFactory = pageObjectsDependenciesFactory
    }
    
    func pageObjectElementFactory() -> PageObjectElementFactory {
        return pageObjectsDependenciesFactory.pageObjectElementFactory()
    }
}
