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
}
