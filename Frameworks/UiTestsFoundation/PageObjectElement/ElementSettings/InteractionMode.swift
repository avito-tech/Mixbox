// The name is maybe misleading. In fact the enum is a mode of selecting unique element among all matching elements.
// Possible extension: `useEveryElement`, it may be useful to calculate count of element,
// or to check if every element is visible. It is not easy because CollectionView/TableView do not show all elements simultaneously.
public enum InteractionMode {
    case useUniqueElement
    case useElementAtIndexInHierarchy(Int)
    
    public static let `default`: InteractionMode = .useUniqueElement
    
    public static let any: InteractionMode = .useElementAtIndexInHierarchy(0)
}
