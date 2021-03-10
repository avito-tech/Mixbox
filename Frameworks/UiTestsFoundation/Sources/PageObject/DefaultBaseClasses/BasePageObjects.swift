// Ready to use base class for your collection of page objects.
// In real and huge projects, with multiple applications, you can make your own implementation with
// all dependencies that you need, with all applications that you need.
//
// This class supports only one application. To support multiple applications,
// implement your own base class with multiple `PageObjectRegistrar`.
open class BasePageObjects: PageObjectRegistrar {
    private let pageObjectRegistrar: PageObjectRegistrar
    
    public init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectRegistrar = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory
        )
    }
    
    open func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
    {
        return pageObjectRegistrar.pageObject(initializer)
    }
}
