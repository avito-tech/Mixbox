public final class PredicateNodeVisibleText {
    public static func ==(left: PredicateNodeVisibleText, right: String) -> PredicateNode {
        return .visibleText(right)
    }
    
    public static func ==(left: String, right: PredicateNodeVisibleText) -> PredicateNode {
        return right == left
    }
}
