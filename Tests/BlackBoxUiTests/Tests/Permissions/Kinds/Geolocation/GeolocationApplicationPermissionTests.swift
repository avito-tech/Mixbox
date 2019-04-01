import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Support "authorizedAlways" properly
// TODO: Support "authorizedWhenInUse" properly
// TODO: Support "restricted"
final class GeolocationApplicationPermissionTests: BasePermissionTestCase {
    private let specification = GeolocationApplicationPermissionSpecification()
    
    func test_set_allowed() {
        check(specification: specification, state: .allowed)
    }
    
    func test_set_denied() {
        check(specification: specification, state: .denied)
    }
    
    func test_set_notDetermined() {
        check(specification: specification, state: .notDetermined)
    }
}
