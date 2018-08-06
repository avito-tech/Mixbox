public final class PredicateNodeType {
    public static func ==(left: PredicateNodeType, right: ElementType) -> PredicateNode {
        return .type(right)
    }
    
    public static func ==(left: ElementType, right: PredicateNodeType) -> PredicateNode {
        return right == left
    }
}
