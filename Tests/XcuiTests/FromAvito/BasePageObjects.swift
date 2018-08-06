import MixboxUiTestsFoundation

// All utility functions are separated from declaration of page objects in this class.
//
// This class can be copypasted to any repository.
// Note this before adding some specific stuff for PageObjects.

public class BasePageObjects: PageObjectsMarkerProtocol {
    fileprivate let pageObjectRegistrar: PageObjectRegistrar
    
    public init(pageObjectsDependenciesFactory: PageObjectsDependenciesFactory) {
        self.pageObjectRegistrar = PageObjectRegistrarImpl(
            pageObjectDependenciesFactory: pageObjectsDependenciesFactory.pageObjectDependenciesFactory()
        )
    }
}

// FIXME: IT CAN NOT BE INTERNAL

// Internal protection level of functions for registering page objects hides
// those functions in tests, this is very handy.
extension BasePageObjects: PageObjectRegistrar {
    public func pageObject<PageObjectType>(
        _ initializer: BasePageObjectInitializer<PageObjectType>)
        -> PageObjectType
    {
        return pageObjectRegistrar.pageObject(initializer)
    }
}
