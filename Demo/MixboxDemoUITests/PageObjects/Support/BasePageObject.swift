import MixboxUiTestsFoundation

// All utility functions are separated from declaration of page object elements in this class.
//
// This class can be copypasted to any repository.
// Note this before adding some specific stuff for PageObject.

open class BasePageObject: PageObject, PageObjectElementRegistrar {
    fileprivate let pageObjectElementRegistrar: PageObjectElementRegistrar
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectElementRegistrar = PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectDependenciesFactory.pageObjectElementDependenciesFactory()
        )
    }
    
    // MARK: - PageObjectElementRegistrar
    
    public func element<T: ElementWithDefaultInitializer>(
        _ name: String,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return pageObjectElementRegistrar.element(name, matcherBuilder: matcherBuilder)
    }
    
    public func with(searchMode: SearchMode) -> PageObjectElementRegistrar {
        return pageObjectElementRegistrar.with(searchMode: searchMode)
    }
    
    public func with(interactionMode: InteractionMode) -> PageObjectElementRegistrar {
        return pageObjectElementRegistrar.with(interactionMode: interactionMode)
    }
}

open class BasePageObjectWithDefaultInitializer:
    BasePageObject,
    PageObjectWithDefaultInitializer
{
    override public required init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        super.init(pageObjectDependenciesFactory: pageObjectDependenciesFactory)
    }
}
