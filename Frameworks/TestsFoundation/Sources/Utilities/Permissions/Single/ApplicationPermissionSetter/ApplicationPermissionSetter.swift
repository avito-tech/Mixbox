import MixboxFoundation

// Facade for setting a single permission.
public protocol ApplicationPermissionSetter: AnyObject {
    func set(_ state: AllowedDeniedNotDeterminedState)
}
