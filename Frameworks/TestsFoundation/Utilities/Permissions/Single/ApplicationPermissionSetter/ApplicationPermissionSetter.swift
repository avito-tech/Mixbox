import MixboxFoundation

// Facade for setting a single permission.
public protocol ApplicationPermissionSetter {
    func set(_ state: AllowedDeniedNotDeterminedState)
}
