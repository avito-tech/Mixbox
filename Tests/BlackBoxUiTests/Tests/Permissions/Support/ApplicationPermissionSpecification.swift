import MixboxTestsFoundation

protocol ApplicationPermissionSpecification {
    var identifier: String { get }
    
    func setter(
        permissions: ApplicationPermissionsSetter)
        -> ApplicationPermissionSetter
    
    func authorizationStatusString(
        state: AllowedDeniedNotDeterminedState)
        -> String
}
