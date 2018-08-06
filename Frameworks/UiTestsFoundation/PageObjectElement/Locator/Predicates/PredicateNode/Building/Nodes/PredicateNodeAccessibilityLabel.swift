public final class PredicateNodeAccessibilityLabel {
    public static func ==(left: PredicateNodeAccessibilityLabel, right: String) -> PredicateNode {
        return .accessibilityLabel(right)
    }
    
    public static func ==(left: String, right: PredicateNodeAccessibilityLabel) -> PredicateNode {
        return right == left
    }
    
    public static func !=(left: PredicateNodeAccessibilityLabel, right: String) -> PredicateNode {
        return !(left == right)
    }
    
    public static func !=(left: String, right: PredicateNodeAccessibilityLabel) -> PredicateNode {
        return !(left == right)
    }
}
