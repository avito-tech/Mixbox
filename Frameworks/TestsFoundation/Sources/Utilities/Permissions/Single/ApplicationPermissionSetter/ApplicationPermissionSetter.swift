import MixboxFoundation

// Facade for setting a single permission.
public protocol ApplicationPermissionSetter: class {
    func set(_ state: AllowedDeniedNotDeterminedState)
}
