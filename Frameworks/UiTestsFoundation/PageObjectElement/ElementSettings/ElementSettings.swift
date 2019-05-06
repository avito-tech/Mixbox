public final class ElementSettings {
    public let elementName: String
    public let matcher: ElementMatcher
    public let searchMode: SearchMode
    public let searchTimeout: TimeInterval // TODO: Rename to interactionTimeout
    public let interactionMode: InteractionMode
    
    public init(
        elementName: String,
        matcher: ElementMatcher,
        searchMode: SearchMode,
        searchTimeout: TimeInterval?, // nil == default
        interactionMode: InteractionMode)
    {
        self.elementName = elementName
        self.matcher = matcher
        self.searchMode = searchMode
        self.searchTimeout = searchTimeout ?? 15
        self.interactionMode = interactionMode
    }
    
    func with(name: String) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(matcher: ElementMatcher) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(searchMode: SearchMode) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(searchTimeout: TimeInterval?) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionMode: InteractionMode) -> ElementSettings {
        return ElementSettings(
            elementName: elementName,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
}

extension ElementSettings {
    public var shouldAutoScroll: Bool {
        return searchMode == .scrollUntilFound
    }
}
