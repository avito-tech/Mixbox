import MixboxFoundation

public final class ElementSettings {
    public let name: String
    public let functionDeclarationLocation: FunctionDeclarationLocation
    public let matcher: ElementMatcher
    public let scrollMode: ScrollMode
    public let interactionTimeout: TimeInterval
    public let interactionMode: InteractionMode
    
    public init(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcher: ElementMatcher,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval?, // nil == default
        interactionMode: InteractionMode)
    {
        self.name = name
        self.functionDeclarationLocation = functionDeclarationLocation
        self.matcher = matcher
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout ?? 15
        self.interactionMode = interactionMode
    }
    
    func with(name: String) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(matcher: ElementMatcher) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(scrollMode: ScrollMode) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionTimeout: TimeInterval?) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionMode: InteractionMode) -> ElementSettings {
        return ElementSettings(
            name: name,
            functionDeclarationLocation: functionDeclarationLocation,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
}
