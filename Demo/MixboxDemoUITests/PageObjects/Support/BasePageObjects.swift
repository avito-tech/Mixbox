import MixboxUiTestsFoundation

class BasePageObjects: PageObjectRegistrar {
    private let pageObjectRegistrar: PageObjectRegistrar
    
    init(pageObjectsDependenciesFactory: PageObjectsDependenciesFactory) {
        self.pageObjectRegistrar = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: pageObjectsDependenciesFactory.pageObjectDependenciesFactory()
        )
    }
    
    func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
    {
        return pageObjectRegistrar.pageObject(initializer)
    }
}
