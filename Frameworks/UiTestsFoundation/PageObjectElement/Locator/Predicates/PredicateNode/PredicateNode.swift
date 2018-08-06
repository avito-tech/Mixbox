// IN DEVELOPMENT.
//
// PredicateNode is an abstraction of predicate for finding element on screen.
//
// It can be either
//
// - a hardcoded enum
//
// or
// 
// - some bunch of protocols and functions
//
// Now it is an enum. It can be rewritten to something else without rewriting any test.
//
// ---------------------
//
// HOW TO EDIT:
//
// Note that matching state of element (text, color, visibility, etc) is not a good
// way to locate a UI element. So think twice before adding it.
//
// It is better to match some static properties of the view (accessibilityId, which is constant
// during view's lifecycle).
//
// If there is no way to match an element but to check its state, feel free to
// match its state in locator and add new cases in this enum.

public indirect enum PredicateNode {
    // Logic
    case and([PredicateNode])
    case or([PredicateNode])
    case not(PredicateNode)
    case alwaysTrue
    case alwaysFalse
    
    // Properties
    case accessibilityId(String)
    case accessibilityPlaceholderValue(String)
    case accessibilityValue(String)
    case accessibilityLabel(String)
    case visibleText(String)
    case type(ElementType)
    
    // Functions
    case isInstanceOf(AnyClass) // consider using type(...) in Functional Tests
    case isSubviewOf(PredicateNode)
}
