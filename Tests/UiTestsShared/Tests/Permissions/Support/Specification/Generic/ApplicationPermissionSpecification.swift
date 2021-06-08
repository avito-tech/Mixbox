import MixboxTestsFoundation

protocol ApplicationPermissionSpecification: AnyObject {
    associatedtype PermissionStateType: CaseIterable
    
    var identifier: String { get }
    
    func set(
        state: PermissionStateType,
        permissions: ApplicationPermissionsSetter)
    
    func authorizationStatusString(
        state: PermissionStateType)
        -> String
}
