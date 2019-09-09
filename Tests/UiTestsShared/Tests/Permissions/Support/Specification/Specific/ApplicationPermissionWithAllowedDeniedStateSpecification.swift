import MixboxTestsFoundation

protocol ApplicationPermissionWithAllowedDeniedStateSpecification: ApplicationPermissionSpecification
    where
    PermissionStateType == AllowedDeniedState
{
    var identifier: String { get }
    
    func setter(
        permissions: ApplicationPermissionsSetter)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
    
    func authorizationStatusString(
        state: AllowedDeniedState)
        -> String
}

extension ApplicationPermissionWithAllowedDeniedStateSpecification {
    func set(
        state: PermissionStateType,
        permissions: ApplicationPermissionsSetter)
    {
        setter(permissions: permissions).set(state)
    }
}
