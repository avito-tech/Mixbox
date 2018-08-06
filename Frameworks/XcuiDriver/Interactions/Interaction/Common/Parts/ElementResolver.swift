import MixboxUiTestsFoundation

protocol ElementResolver {
    func resolveElement() -> ResolvedElementQuery
}

final class ElementResolverImpl: ElementResolver {
    private let elementFinder: ElementFinder
    private let elementSettings: ElementSettings
    
    init(
        elementFinder: ElementFinder,
        elementSettings: ElementSettings)
    {
        self.elementFinder = elementFinder
        self.elementSettings = elementSettings
    }
    
    func resolveElement() -> ResolvedElementQuery {
        let elementQuery = elementFinder.query(
            elementSnapshotMatcher: ElementSnapshotMatchers.and(
                [
                    ElementSnapshotMatchers.matcherForPredicate(
                        elementSettings.matcher.rootPredicateNode
                    ),
                    ElementSnapshotMatchers.isNotDefinitelyHidden()
                ]
            ),
            waitForExistence: false
        )
        
        let xcuiElementQueryResolver: (XCUIElementQuery) -> (XCUIElement)
        
        switch elementSettings.interactionMode {
        case .useUniqueElement:
            xcuiElementQueryResolver = { query in query.element }
        case .useElementAtIndexInHierarchy(let index):
            xcuiElementQueryResolver = { query in query.element(boundBy: index) }
        }
        
        return elementQuery.resolveElement(xcuiElementQueryResolver)
    }
}
