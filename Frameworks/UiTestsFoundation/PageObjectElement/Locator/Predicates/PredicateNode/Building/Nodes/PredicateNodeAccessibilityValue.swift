public final class PredicateNodeAccessibilityValue {
    public static func ==(left: PredicateNodeAccessibilityValue, right: String) -> PredicateNode {
        return .accessibilityValue(right)
    }
    
    public static func ==(left: String, right: PredicateNodeAccessibilityValue) -> PredicateNode {
        return right == left
    }
    
    public static func !=(left: PredicateNodeAccessibilityValue, right: String) -> PredicateNode {
        return !(left == right)
    }
    
    public static func !=(left: String, right: PredicateNodeAccessibilityValue) -> PredicateNode {
        return !(left == right)
    }
}
