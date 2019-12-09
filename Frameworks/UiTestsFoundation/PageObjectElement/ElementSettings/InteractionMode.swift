// The name is maybe misleading. In fact the enum is a mode of selecting unique element among all matching elements.
// Possible extension: `useEveryElement`, it may be useful to calculate count of element,
// or to check if every element is visible. It is not easy because CollectionView/TableView do not show all elements simultaneously.
public enum InteractionMode: Equatable {
    case useUniqueElement
    case useElementAtIndexInHierarchy(Int)
    
    public static let `default`: InteractionMode = .useUniqueElement
    
    public static let any: InteractionMode = .useElementAtIndexInHierarchy(0)
    
    public static func ==(lhs: InteractionMode, rhs: InteractionMode) -> Bool {
        switch (lhs, rhs) {
        case (.useUniqueElement, .useUniqueElement):
            return true
        case let (.useElementAtIndexInHierarchy(lhs), .useElementAtIndexInHierarchy(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
