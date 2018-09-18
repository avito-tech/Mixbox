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
