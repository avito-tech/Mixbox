import MixboxUiTestsFoundation
import MixboxFoundation

// All utility functions are separated from declaration of page object elements in this class.
//
// This class can be copypasted to any repository.
// Note this before adding some specific stuff for PageObject.
//
// TODO: Move some code somewhere to Mixbox?

open class BasePageObject: PageObject, PageObjectElementRegistrar {
    fileprivate let pageObjectElementRegistrar: PageObjectElementRegistrar
    
    init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.pageObjectElementRegistrar = PageObjectElementRegistrarImpl(
            pageObjectElementDependenciesFactory: pageObjectDependenciesFactory.pageObjectElementDependenciesFactory()
        )
    }
    
    // MARK: - PageObjectElementRegistrar
    
    public func elementImpl<T>(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: (ElementMatcherBuilder) -> ElementMatcher)
        -> T
        where
        T: ElementWithDefaultInitializer
    {
        return pageObjectElementRegistrar.elementImpl(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcherBuilder: matcherBuilder
        )
    }
    
    public func with(scrollMode: ScrollMode) -> PageObjectElementRegistrar {
        return pageObjectElementRegistrar.with(scrollMode: scrollMode)
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
        super.init(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory
        )
    }
}
