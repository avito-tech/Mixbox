import MixboxTestsFoundation

protocol ApplicationPermissionSpecification: class {
    associatedtype PermissionStateType
    
    var identifier: String { get }
    
    func set(
        state: PermissionStateType,
        permissions: ApplicationPermissionsSetter)
    
    func authorizationStatusString(
        state: PermissionStateType)
        -> String
}
