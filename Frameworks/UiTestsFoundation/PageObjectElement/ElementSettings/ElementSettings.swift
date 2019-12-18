import MixboxFoundation

public final class ElementSettings {
    public let elementName: String
    public let fileLine: FileLine
    public let function: String
    public let matcher: ElementMatcher
    public let scrollMode: ScrollMode
    public let interactionTimeout: TimeInterval
    public let interactionMode: InteractionMode
    
    public init(
        elementName: String,
        fileLine: FileLine,
        function: String,
        matcher: ElementMatcher,
        scrollMode: ScrollMode,
        interactionTimeout: TimeInterval?, // nil == default
        interactionMode: InteractionMode)
    {
        self.elementName = elementName
        self.fileLine = fileLine
        self.function = function
        self.matcher = matcher
        self.scrollMode = scrollMode
        self.interactionTimeout = interactionTimeout ?? 15
        self.interactionMode = interactionMode
    }
    
    func with(name: String) -> ElementSettings {
        return ElementSettings(
            elementName: name,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(matcher: ElementMatcher) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(scrollMode: ScrollMode) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionTimeout: TimeInterval?) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionMode: InteractionMode) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            scrollMode: scrollMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
}
