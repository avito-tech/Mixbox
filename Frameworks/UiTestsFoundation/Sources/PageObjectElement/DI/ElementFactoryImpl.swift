import MixboxFoundation
import UIKit

public final class ElementFactoryImpl: ElementFactory {
    private let pageObjectDependenciesFactory: PageObjectDependenciesFactory
    private let elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider
    
    private let scrollMode: ScrollMode
    private let interactionTimeout: TimeInterval
    private let interactionMode: InteractionMode
    private let percentageOfVisibleArea: CGFloat
    private let pixelPerfectVisibilityCheck: Bool
    
    public init(
        pageObjectDependenciesFactory: PageObjectDependenciesFactory,
        elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval,
        interactionMode: InteractionMode,
        percentageOfVisibleArea: CGFloat,
        pixelPerfectVisibilityCheck: Bool)
    {
        self.pageObjectDependenciesFactory = pageObjectDependenciesFactory
        self.elementSettingsDefaultsProvider = elementSettingsDefaultsProvider
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout
        self.interactionMode = interactionMode
        self.percentageOfVisibleArea = percentageOfVisibleArea
        self.pixelPerfectVisibilityCheck = pixelPerfectVisibilityCheck
    }
    
    public convenience init(
        pageObjectDependenciesFactory: PageObjectDependenciesFactory)
    {
        let elementSettingsDefaultsProvider = pageObjectDependenciesFactory.elementSettingsDefaultsProvider
        let elementSettingsDefaults = elementSettingsDefaultsProvider.elementSettingsDefaults()
        
        self.init(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: elementSettingsDefaults.scrollMode,
            interactionTimeout: elementSettingsDefaults.interactionTimeout,
            interactionMode: elementSettingsDefaults.interactionMode,
            percentageOfVisibleArea: elementSettingsDefaults.percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: elementSettingsDefaults.pixelPerfectVisibilityCheck
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
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode ?? elementSettingsDefaultsProvider.elementSettingsDefaults().scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(interactionTimeout: TimeInterval?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout ?? elementSettingsDefaultsProvider.elementSettingsDefaults().interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(interactionMode: InteractionMode?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode ?? elementSettingsDefaultsProvider.elementSettingsDefaults().interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(percentageOfVisibleArea: CGFloat?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea ?? elementSettingsDefaultsProvider.elementSettingsDefaults().percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(pixelPerfectVisibilityCheck: Bool?) -> ElementFactory {
        return ElementFactoryImpl(
            pageObjectDependenciesFactory: pageObjectDependenciesFactory,
            elementSettingsDefaultsProvider: elementSettingsDefaultsProvider,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck ?? elementSettingsDefaultsProvider.elementSettingsDefaults().pixelPerfectVisibilityCheck
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
                name: name,
                functionDeclarationLocation: functionDeclarationLocation,
                matcher: matcherBuilderClosure(elementMatcherBuilder),
                elementSettingsDefaults: ElementSettingsDefaults(
                    scrollMode: scrollMode,
                    interactionTimeout: interactionTimeout,
                    interactionMode: interactionMode,
                    percentageOfVisibleArea: percentageOfVisibleArea,
                    pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
                )
            )
        )
    }
}
