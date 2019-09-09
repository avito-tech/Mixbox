import MixboxTestsFoundation

protocol ApplicationPermissionWithAllowedDeniedNotDeterminedStateSpecification:
    ApplicationPermissionSpecification where PermissionStateType == AllowedDeniedNotDeterminedState
{
    func setter(
        permissions: ApplicationPermissionsSetter)
        -> ApplicationPermissionSetter
}

extension ApplicationPermissionWithAllowedDeniedNotDeterminedStateSpecification {
    func set(
        state: PermissionStateType,
        permissions: ApplicationPermissionsSetter)
    {
        setter(permissions: permissions).set(state)
    }
}
