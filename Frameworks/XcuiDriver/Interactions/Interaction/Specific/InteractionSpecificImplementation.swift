import MixboxUiTestsFoundation

// `Interaction` is a generic interaction with an element.
// All specific lies inside `InteractionSpecificImplementation` which is stored by `Interaction`.
// E.g. every interaction needs to find an element. Only interaction for tapping needs to tap an element.
final class InteractionSpecificImplementation {
    typealias ExecuteFunction = (_ element: XCUIElement, _ snapshot: ElementSnapshot) -> InteractionSpecificResult
    private let execute: ExecuteFunction
    
    init(execute: @escaping ExecuteFunction) {
        self.execute = execute
    }
    
    func perform(element: XCUIElement, snapshot: ElementSnapshot) -> InteractionSpecificResult {
        return execute(element, snapshot)
    }
}
