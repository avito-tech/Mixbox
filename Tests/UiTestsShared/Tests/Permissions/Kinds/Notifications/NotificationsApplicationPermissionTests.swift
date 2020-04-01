import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Share with GrayBoxUiTests
final class NotificationsApplicationPermissionTests: BasePermissionTestCase {
    private let specification = NotificationsApplicationPermissionSpecification()
    
    func test_set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test_set_denied() {
        check(specification: specification, state: .denied)
    }
    
    func disabled_test___set___can_be_called_sequentially() {
        check___set___can_be_called_sequentially(specification: specification)
    }
}
