import MixboxFoundation
import UIKit

public final class ElementFactoryImpl: ElementFactory {
    private let pageObjectDependenciesFactory: PageObjectDependenciesFactory
    private let interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider
    private let elementFactoryElementSettings: ElementFactoryElementSettings
    
    public init(
        pageObjectDependenciesFactory: PageObjectDependenciesFactory,
        interactionSettingsDefaultsProvider: InteractionSettingsDefaultsProvider,
        elementFactoryElementSettings: ElementFactoryElementSettings)
    {
        self.pageObjectDependenciesFactory = pageObjectDependenciesFactory
        self.interactionSettingsDefaultsProvider = interactionSettingsDefaultsProvider
        self.elementFactoryElementSettings = elementFactoryElementSettings
    }
    
    public convenience init(
        pageObjectDependenciesFactory: PageObjectDependenciesFactory)
    {
        self.init(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            interactionSettingsDefaultsProvider: pageObjectDependenciesFactory.interactionSettingsDefaultsProvider,
            elementFactoryElementSettings: ElementFactoryElementSettings(
                scrollMode: .automatic,
                interactionTimeout: .automatic,
                interactionMode: .automatic,
                percentageOfVisibleArea: .automatic,
                pixelPerfectVisibilityCheck: .automatic
            )
        )
    }
    
    // MARK: - ElementFactory
    
    public func element<T>(
        name: String,
        factory: (PageObjectElementCore) -> T,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return factory(
            pageObjectElementCore(
                name: name,
                functionDeclarationLocation: functionDeclarationLocation,
                matcherBuilderClosure: matcherBuilder
            )
        )
    }
    
    public var with: FieldBuilder<SubstructureFieldBuilderCallImplementation<ElementFactory, ElementFactoryElementSettings>> {
        return FieldBuilder(
            callImplementation: SubstructureFieldBuilderCallImplementation(
                structure: self,
                getSubstructure: { $0.elementFactoryElementSettings },
                getResult: { structure, substructure in
                    ElementFactoryImpl(
                        pageObjectDependenciesFactory: structure.pageObjectDependenciesFactory,
                        interactionSettingsDefaultsProvider: structure.interactionSettingsDefaultsProvider,
                        elementFactoryElementSettings: substructure
                    )
                }
            )
        )
    }
    
    // MARK: - Private
    
    private func pageObjectElementCore(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilderClosure: ElementMatcherBuilderClosure)
        -> PageObjectElementCore
    {
        let pageObjectElementCoreFactory = pageObjectDependenciesFactory.pageObjectElementCoreFactory
        let elementMatcherBuilder = pageObjectDependenciesFactory.matcherBulder
        
        return pageObjectElementCoreFactory.pageObjectElementCore(
            settings: ElementSettings(
                interactionSettingsDefaultsProvider: interactionSettingsDefaultsProvider,
                elementFactoryElementSettings: elementFactoryElementSettings,
                functionDeclarationLocation: functionDeclarationLocation,
                name: name,
                matcher: matcherBuilderClosure(elementMatcherBuilder)
            )
        )
    }
}
