protocol PermissionInfo: AnyObject {
    func identifier() -> String
    func authorizationStatus() -> String
}
