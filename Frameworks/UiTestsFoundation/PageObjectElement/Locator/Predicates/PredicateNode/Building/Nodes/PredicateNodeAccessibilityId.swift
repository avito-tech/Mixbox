public final class PredicateNodeAccessibilityId {
    public static func ==(left: PredicateNodeAccessibilityId, right: String) -> PredicateNode {
        return .accessibilityId(right)
    }
    
    public static func ==(left: String, right: PredicateNodeAccessibilityId) -> PredicateNode {
        return right == left
    }
    
    public static func !=(left: PredicateNodeAccessibilityId, right: String) -> PredicateNode {
        return !(left == right)
    }
    
    public static func !=(left: String, right: PredicateNodeAccessibilityId) -> PredicateNode {
        return !(left == right)
    }
}
