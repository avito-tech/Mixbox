import MixboxUiTestsFoundation
import TestsIpc

protocol AnyActionSpecification: class {
    var elementId: String { get }
    var expectedResult: ActionsTestsViewActionResult { get }
    
    func performAction(screen: ActionsTestsViewPageObject)
}
