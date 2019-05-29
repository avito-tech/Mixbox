import MixboxUiTestsFoundation

class BasePageObjects: PageObjectRegistrar {
    private let pageObjectRegistrar: PageObjectRegistrar
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectRegistrar = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory
        )
    }
    
    func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
    {
        return pageObjectRegistrar.pageObject(initializer)
    }
}
