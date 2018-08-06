public enum SearchMode {
    // Ничего не делать
    case useCurrentlyVisible
    // Скроллить до элемента в иерархии
    case scrollUntilFound
    
    // Временная заглушка для слепого поиска
    // (когда элементы появляются только после скроллинга и это не collection view)
    case scrollBlindly
    
    public static let `default`: SearchMode = .scrollUntilFound
}

public enum InteractionMode {
    // Возможное расширение: case useEveryElement
    // Например, пригодится для подсчетов количества.
    // Затруднительно без реализации прогрузки всех ячеек CollectionView/TableView.
    case useUniqueElement
    case useElementAtIndexInHierarchy(Int)
    
    public static let `default`: InteractionMode = .useUniqueElement
    
    public static let any: InteractionMode = .useElementAtIndexInHierarchy(0)
}

public final class ElementSettings {
    public let name: String
    public let matcher: ElementMatcher
    public let searchMode: SearchMode
    public let searchTimeout: TimeInterval?
    public let interactionMode: InteractionMode
    
    public init(
        name: String,
        matcher: ElementMatcher,
        searchMode: SearchMode,
        searchTimeout: TimeInterval?, // nil == default
        interactionMode: InteractionMode)
    {
        self.name = name
        self.matcher = matcher
        self.searchMode = searchMode
        self.searchTimeout = searchTimeout
        self.interactionMode = interactionMode
    }
    
    func with(name: String) -> ElementSettings {
        return ElementSettings(
            name: name,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(matcher: ElementMatcher) -> ElementSettings {
        return ElementSettings(
            name: name,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(searchMode: SearchMode) -> ElementSettings {
        return ElementSettings(
            name: name,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(searchTimeout: TimeInterval?) -> ElementSettings {
        return ElementSettings(
            name: name,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
    
    func with(interactionMode: InteractionMode) -> ElementSettings {
        return ElementSettings(
            name: name,
            matcher: matcher,
            searchMode: searchMode,
            searchTimeout: searchTimeout,
            interactionMode: interactionMode
        )
    }
}
