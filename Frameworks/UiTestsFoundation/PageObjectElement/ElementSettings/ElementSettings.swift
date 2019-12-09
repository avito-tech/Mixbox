import MixboxFoundation

public final class ElementSettings {
    public let elementName: String
    public let fileLine: FileLine
    public let function: String
    public let matcher: ElementMatcher
    public let searchMode: SearchMode
    public let interactionTimeout: TimeInterval
    public let interactionMode: InteractionMode
    
    public init(
        elementName: String,
        fileLine: FileLine,
        function: String,
        matcher: ElementMatcher,
        searchMode: SearchMode,
        interactionTimeout: TimeInterval?, // nil == default
        interactionMode: InteractionMode)
    {
        self.elementName = elementName
        self.fileLine = fileLine
        self.function = function
        self.matcher = matcher
        self.searchMode = searchMode
        self.interactionTimeout = interactionTimeout ?? 15
        self.interactionMode = interactionMode
    }
    
    func with(name: String) -> ElementSettings {
        return ElementSettings(
            elementName: name,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            searchMode: searchMode,
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
            searchMode: searchMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(searchMode: SearchMode) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            fileLine: fileLine,
            function: function,
            matcher: matcher,
            searchMode: searchMode,
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
            searchMode: searchMode,
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
            searchMode: searchMode,
            interactionTimeout: interactionTimeout,
            interactionMode: interactionMode
        )
    }
}

extension ElementSettings {
    public var shouldAutoScroll: Bool {
        return searchMode == .scrollUntilFound
    }
}
