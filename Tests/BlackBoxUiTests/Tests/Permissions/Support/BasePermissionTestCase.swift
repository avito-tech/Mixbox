import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: Check both "before" and "after" application start. This will require making IPC method or polling in the view.
class BasePermissionTestCase: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func check(
        specification: ApplicationPermissionSpecification,
        state: AllowedDeniedNotDeterminedState)
    {
        specification.setter(permissions: permissions).set(state)
        
        openScreen(name: "PermissionsTestsView")
        
        pageObjects.generic.label(specification.identifier).assert.matches { [specification] element in
            let expectedStatus = specification.authorizationStatusString(state: state)
            return element.customValues["authorizationStatus"] == expectedStatus
        }
    }
}
