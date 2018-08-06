// This class contatins everything to make a specific matcher of element
// E.g.: for EarlGrey it can be converted to EarlGrey matcher.
//
// Note that rootPredicateNode can be replaced with something else with same functionality of
// specifying page object element matcher.
//
// TODO: Rename? The name is a bit misleading. The protocol doesn't actually match anything,
// but it is used for matching elements by providing PredicateNode (which is used to find element in UI)
//
public final class ElementMatcher {
    public let rootPredicateNode: PredicateNode
    
    public init(rootPredicateNode: PredicateNode) {
        self.rootPredicateNode = rootPredicateNode
    }
    
    public convenience init(builder: (PredicateNodePageObjectElement) -> PredicateNode) {
        self.init(
            rootPredicateNode: builder(PredicateNodePageObjectElement())
        )
    }
}
