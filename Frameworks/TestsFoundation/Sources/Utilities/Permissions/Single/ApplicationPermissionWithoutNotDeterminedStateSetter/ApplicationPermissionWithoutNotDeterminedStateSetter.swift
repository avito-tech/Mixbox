import MixboxFoundation

public protocol ApplicationPermissionWithoutNotDeterminedStateSetter  {
    func set(_ state: AllowedDeniedState)
}
