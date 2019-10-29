import MixboxTestsFoundation
import MixboxUiTestsFoundation

// TODO: (BlackBoxTests) Check both "before" and "after" application start.
//       This will require making IPC method or polling in the view.
//
// TODO: (GrayBoxTests) Check alternating states within a single test / application run.
//       It does not work! authorizationStatus doesn't get updated for .camera for example.
//
// TODO: Also check without Emcee on CI (without kludges for fbxctest)
class BasePermissionTestCase: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func check<Spec: ApplicationPermissionSpecification>(
        specification: Spec,
        state: Spec.PermissionStateType)
    {
        specification.set(
            state: state,
            permissions: permissions
        )
        
        openScreen(name: "PermissionsTestsView")
        
        pageObjects.generic.label(specification.identifier).assertMatches { [specification] element in
            let expectedStatus = specification.authorizationStatusString(state: state)
            return element.customValues["authorizationStatus"] == expectedStatus
        }
    }
}
