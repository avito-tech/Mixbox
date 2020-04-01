import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Test "restricted" authorizations state.
final class CameraApplicationPermissionTests: BasePermissionTestCase {
    private let specification = CameraApplicationPermissionSpecification()
    
    func test___set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test___set_denied() {
        check(specification: specification, state: .denied)
    }
    
    func test___set_notDetermined() {
        check(specification: specification, state: .notDetermined)
    }
    
    func disabled_test___set___can_be_called_sequentially() {
        check___set___can_be_called_sequentially(specification: specification)
    }
}
