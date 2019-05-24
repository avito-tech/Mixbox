import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class NotificationsApplicationPermissionTests: BasePermissionTestCase {
    private let specification = NotificationsApplicationPermissionSpecification()
    
    func test_set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test_set_denied() {
        check(specification: specification, state: .denied)
    }
}
