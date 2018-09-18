public enum InteractionMode {
    // Возможное расширение: case useEveryElement
    // Например, пригодится для подсчетов количества.
    // Затруднительно без реализации прогрузки всех ячеек CollectionView/TableView.
    case useUniqueElement
    case useElementAtIndexInHierarchy(Int)
    
    public static let `default`: InteractionMode = .useUniqueElement
    
    public static let any: InteractionMode = .useElementAtIndexInHierarchy(0)
}
