import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Test "restricted" authorizations state.
final class MicrophoneApplicationPermissionTests: BasePermissionTestCase {
    private let specification = MicrophoneApplicationPermissionSpecification()
    
    func test_set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test_set_denied() {
        check(specification: specification, state: .denied)
    }
    
    func disabled_test_set_notDetermined() {
        check(specification: specification, state: .notDetermined)
    }
}
