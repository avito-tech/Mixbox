import MixboxUiTestsFoundation

public class BasePageObjects: PageObjectsMarkerProtocol {
    private let pageObjectRegistrar: PageObjectRegistrar
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectRegistrar = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory
        )
    }

    func pageObject<PageObjectType: PageObjectWithDefaultInitializer>() -> PageObjectType {
        return pageObjectRegistrar.pageObject(PageObjectType.init)
    }
}
