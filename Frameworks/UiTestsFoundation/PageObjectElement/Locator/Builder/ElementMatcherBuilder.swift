// Helper for building ElementMatcher
//
// This class allows you to write locators like this:
//
//     { element in
//         element.id == "myId" && element.text = "OK"
//     }
//
//     { element in
//         element.id == "myId"
//         && element.text == "Next"
//         && element.label == "Next keyboard"
//         && element.isSubviewOf { anotherElement in
//             anotherElement.isInstanceOf(UIScrollView.self)
//             && anotherElement.id == "myScrollView"
//         }
//     }
//
// So this class does nothing except for providing syntactic sugar.
//
// TODO: сделать element == otherElement

public typealias ElementMatcherBuilderClosure = (ElementMatcherBuilder) -> ElementMatcher

public final class ElementMatcherBuilder {
    // We were comparing `String` to `String?` before, this is a temporary kludge to achieve same behavior.
    // Before: func a(b: String, c: String?) { return b == c } // if c == nil, then false is returned
    // After: func a(b: String, c: String) { return b == c } // if c is uuid, then false is returned
    private static let valueToMimicComparisonOfStringToNil = "ACD2E838-5F3E-4971-BAE9-0087D9A864FB"
    
    public let id = PropertyMatcherBuilder("id", \ElementSnapshot.accessibilityIdentifier)
    public let label = PropertyMatcherBuilder("label", \ElementSnapshot.accessibilityLabel)
    public let value = PropertyMatcherBuilder<ElementSnapshot, String>("value") { (snapshot: ElementSnapshot) -> String in
        (snapshot.accessibilityValue as? String) ?? valueToMimicComparisonOfStringToNil // TODO: Support nils and other types
    }
    public let placeholderValue = PropertyMatcherBuilder<ElementSnapshot, String>("placeholderValue") {
        $0.accessibilityPlaceholderValue ?? valueToMimicComparisonOfStringToNil // TODO: Support nils
    }
    public let visibleText = PropertyMatcherBuilder<ElementSnapshot, String>("visibleText") {
        $0.visibleText(fallback: $0.accessibilityLabel) ?? "" // TODO: Support nils, remove fallbacks
    }
    public let isEnabled = PropertyMatcherBuilder("isEnabled", \ElementSnapshot.isEnabled)
    public let type = PropertyMatcherBuilder("type", \ElementSnapshot.elementType)
    
    public let customValues = CustomValuesMatcherBuilder()
    
    public init() {
    }
    
    public func isInstanceOf(_ class: AnyClass) -> ElementMatcher {
        return IsInstanceMatcher("\(`class`)")
    }
    
    public func isInstanceOf(_ class: String) -> ElementMatcher {
        return IsInstanceMatcher(`class`)
    }
    
    public func isSubviewOf(
        _ matcher: ElementMatcherBuilderClosure)
        -> ElementMatcher
    {
        return IsSubviewMatcher(ElementMatcherBuilder.build(matcher))
    }
    
    public static func build(_ closure: ElementMatcherBuilderClosure) -> ElementMatcher {
        return closure(ElementMatcherBuilder())
    }
}
