import MixboxFoundation

public final class ElementSettings {
    public let name: String
    public let functionDeclarationLocation: FunctionDeclarationLocation
    public let matcher: ElementMatcher
    public let elementSettingsDefaults: ElementSettingsDefaults
    public let scrollMode: ScrollMode
    public let interactionTimeout: TimeInterval
    public let interactionMode: InteractionMode
    public let percentageOfVisibleArea: CGFloat
    public let pixelPerfectVisibilityCheck: Bool
    
    public init(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcher: ElementMatcher,
        elementSettingsDefaults: ElementSettingsDefaults,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval,
        interactionMode: InteractionMode,
        percentageOfVisibleArea: CGFloat,
        pixelPerfectVisibilityCheck: Bool)
    {
        self.name = name
        self.functionDeclarationLocation = functionDeclarationLocation
        self.matcher = matcher
        self.elementSettingsDefaults = elementSettingsDefaults
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout
        self.interactionMode = interactionMode
        self.percentageOfVisibleArea = percentageOfVisibleArea
        self.pixelPerfectVisibilityCheck = pixelPerfectVisibilityCheck
    }
    
    public convenience init(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcher: ElementMatcher,
        elementSettingsDefaults: ElementSettingsDefaults)
    {
        self.init(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: elementSettingsDefaults.scrollMode,
            interactionTimeout: elementSettingsDefaults.interactionTimeout,
            interactionMode: elementSettingsDefaults.interactionMode,
            percentageOfVisibleArea: elementSettingsDefaults.percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: elementSettingsDefaults.pixelPerfectVisibilityCheck
        )
    }
    
    public func with(name: String) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(matcher: ElementMatcher) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(scrollMode: ScrollMode?) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode ?? elementSettingsDefaults.scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(interactionTimeout: TimeInterval?) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout ?? elementSettingsDefaults.interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(interactionMode: InteractionMode?) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode ?? elementSettingsDefaults.interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(percentageOfVisibleArea: CGFloat?) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea ?? elementSettingsDefaults.percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
    
    public func with(pixelPerfectVisibilityCheck: Bool) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            elementSettingsDefaults: elementSettingsDefaults,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode,
            percentageOfVisibleArea: percentageOfVisibleArea,
            pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck
        )
    }
}
