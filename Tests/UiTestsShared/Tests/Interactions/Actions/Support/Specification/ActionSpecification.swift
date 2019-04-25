import MixboxUiTestsFoundation

class ActionSpecification<T: Element>: AnyActionSpecification {
    let elementId: String
    let element: (ActionsTestsScreen) -> (T)
    let action: (T) -> ()
    let expectedResult: String
    
    init(
        elementId: String,
        element: @escaping (ActionsTestsScreen) -> (T),
        action: @escaping (T) -> (),
        expectedResult: String)
    {
        self.elementId = elementId
        self.element = element
        self.action = action
        self.expectedResult = expectedResult
    }
    
    func performAction(screen: ActionsTestsScreen) {
        action(element(screen))
    }
}

extension ActionSpecification where T: ElementWithDefaultInitializer {
    convenience init(
        elementId: String,
        action: @escaping (T) -> (),
        expectedResult: String)
    {
        self.init(
            elementId: elementId,
            element: { screen in
                screen.element(elementId) { element in element.id == elementId } as T
            },
            action: action,
            expectedResult: expectedResult
        )
    }
}
