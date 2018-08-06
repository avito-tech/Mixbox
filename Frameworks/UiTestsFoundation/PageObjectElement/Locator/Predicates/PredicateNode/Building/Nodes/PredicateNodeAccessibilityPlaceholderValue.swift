public final class PredicateNodeAccessibilityPlaceholderValue {
    public static func ==(left: PredicateNodeAccessibilityPlaceholderValue, right: String) -> PredicateNode {
        return .accessibilityPlaceholderValue(right)
    }
    
    public static func ==(left: String, right: PredicateNodeAccessibilityPlaceholderValue) -> PredicateNode {
        return right == left
    }
    
    public static func !=(left: PredicateNodeAccessibilityPlaceholderValue, right: String) -> PredicateNode {
        return !(left == right)
    }
    
    public static func !=(left: String, right: PredicateNodeAccessibilityPlaceholderValue) -> PredicateNode {
        return !(left == right)
    }
}
