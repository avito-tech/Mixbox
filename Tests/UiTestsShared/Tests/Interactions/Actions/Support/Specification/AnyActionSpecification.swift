import MixboxUiTestsFoundation
import TestsIpc

protocol AnyActionSpecification: AnyObject {
    var elementId: String { get }
    var expectedResult: ActionsTestsViewActionResult { get }
    
    func performAction(screen: ActionsTestsViewPageObject)
}
