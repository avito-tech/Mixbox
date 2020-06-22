import MixboxFoundation
import Foundation
import UIKit

public final class ElementFactoryImpl: ElementFactory {
    private let pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory
    private let elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider
    
    private let scrollMode: ScrollMode
    private let interactionTimeout: TimeInterval
    private let interactionMode: InteractionMode
    private let percentageOfVisibleArea: CGFloat
    
    public init(
        pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory,
        elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval,
        interactionMode: InteractionMode,
        percentageOfVisibleArea: CGFloat)
    {
        self.pageObjectElementDependenciesFactory = pageObjectElementDependenciesFactory
        self.elementSettingsDefaultsProvider = elementSettingsDefaultsProvider
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout
        self.interactionMode = interactionMode
        self.percentageOfVisibleArea = percentageOfVisibleArea
    }
    
    public convenience init(
        pageObjectElementDependenciesFactory: PageObjectElementDependenciesFactory,
        elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider)
    {
        let elementSettingsDefaults = elementSettingsDefaultsProvider.elementSettingsDefaults()
        
        self.init(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: elementSettingsDefaults.scrollMode,
            interactionTimeout: elementSettingsDefaults.interactionTimeout,
            interactionMode: elementSettingsDefaults.interactionMode,
            percentageOfVisibleArea: elementSettingsDefaults.percentageOfVisibleArea
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
    
    public func with(scrollMode: ScrollMode?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode ?? elementSettingsDefaultsProvider.elementSettingsDefaults().scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea
        )
    }
    
    public func with(interactionTimeout: TimeInterval?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout ?? elementSettingsDefaultsProvider.elementSettingsDefaults().interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea
        )
    }
    
    public func with(interactionMode: InteractionMode?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode ?? elementSettingsDefaultsProvider.elementSettingsDefaults().interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea
        )
    }
    
    public func with(percentageOfVisibleArea: CGFloat?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectElementDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea ?? elementSettingsDefaultsProvider.elementSettingsDefaults().percentageOfVisibleArea
        )
    }
    
    // MARK: - Private
    
    private func pageObjectElementCore(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilderClosure: ElementMatcherBuilderClosure)
        -> PageObjectElementCore
    {
        let pageObjectElementCoreFactory = pageObjectElementDependenciesFactory.pageObjectElementCoreFactory()
        let elementMatcherBuilder = pageObjectElementDependenciesFactory.matcherBulder()
        
        return pageObjectElementCoreFactory.pageObjectElementCore(
            settings: ElementSettings(
                name: name,
                functionDeclarationLocation: functionDeclarationLocation,
                matcher: matcherBuilderClosure(elementMatcherBuilder),
                elementSettingsDefaults: ElementSettingsDefaults(
                    scrollMode: scrollMode,
                    interactionTimeout: interactionTimeout,
                    interactionMode: interactionMode,
                    percentageOfVisibleArea: percentageOfVisibleArea
                )
            )
        )
    }
}
