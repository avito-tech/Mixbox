import MixboxUiTestsFoundation
import TestsIpc

class ActionSpecification<T: Element>: AnyActionSpecification {
    let elementId: String
    let element: (ActionsTestsViewPageObject) -> (T)
    let action: (T) -> ()
    let expectedResult: ActionsTestsViewActionResult
    
    init(
        elementId: String,
        element: @escaping (ActionsTestsViewPageObject) -> (T),
        action: @escaping (T) -> (),
        expectedResult: ActionsTestsViewActionResult)
    {
        self.elementId = elementId
        self.element = element
        self.action = action
        self.expectedResult = expectedResult
    }
    
    func performAction(screen: ActionsTestsViewPageObject) {
        action(element(screen))
    }
}

extension ActionSpecification where T: ElementWithDefaultInitializer {
    convenience init(
        elementId: String,
        action: @escaping (T) -> (),
        expectedResult: ActionsTestsViewActionResult)
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
