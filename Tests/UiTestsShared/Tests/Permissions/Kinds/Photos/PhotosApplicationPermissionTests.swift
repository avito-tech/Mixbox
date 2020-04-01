import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Test "restricted" authorizations state.
final class PhotosApplicationPermissionTests: BasePermissionTestCase {
    private let specification = PhotosApplicationPermissionSpecification()
    
    func test_set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test_set_denied() {
        check(specification: specification, state: .denied)
    }
    
    func test_set_notDetermined() {
        check(specification: specification, state: .notDetermined)
    }
    
    func disabled_test___set___can_be_called_sequentially() {
        check___set___can_be_called_sequentially(specification: specification)
    }
}
