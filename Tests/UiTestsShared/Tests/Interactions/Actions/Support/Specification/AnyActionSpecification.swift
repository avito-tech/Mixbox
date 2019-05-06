import MixboxUiTestsFoundation
import TestsIpc

protocol AnyActionSpecification {
    var elementId: String { get }
    var expectedResult: ActionsTestsViewActionResult { get }
    
    func performAction(screen: ActionsTestsScreen)
}
