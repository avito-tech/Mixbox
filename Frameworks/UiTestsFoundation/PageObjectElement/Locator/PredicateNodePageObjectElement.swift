// Helper for building ElementMatcher
//
// This class allows you to write locators like this:
//
//     { element in
//         element.id == "myId" && element.id.text = "OK"
//     }
//
//     { element in
//         element.id == "myId"
//         && element.text = "Next"
//         && element.label = "Next keyboard"
//         && element.isSubviewOf { anotherElement in
//             anotherElement.isInstanceOf(UIScrollView.self)
//             && anotherElement.id == "myScrollView"
//         }
//     }
//
// So this class does nothing except for providing syntactic sugar.
//
// TODO: сделать element == otherElement

public final class PredicateNodePageObjectElement {
    public let id = PredicateNodeAccessibilityId()
    public let label = PredicateNodeAccessibilityLabel()
    public let value = PredicateNodeAccessibilityValue()
    public let placeholderValue = PredicateNodeAccessibilityPlaceholderValue()
    public let visibleText = PredicateNodeVisibleText()
    public let type = PredicateNodeType()
    
    public func isInstanceOf(_ class: AnyClass) -> PredicateNode {
        return .isInstanceOf(`class`)
    }
    
    public func isSubviewOf(
        _ matcher: (PredicateNodePageObjectElement) -> (PredicateNode))
        -> PredicateNode
    {
        let predicateNode = matcher(PredicateNodePageObjectElement())
        return .isSubviewOf(predicateNode)
    }
}
