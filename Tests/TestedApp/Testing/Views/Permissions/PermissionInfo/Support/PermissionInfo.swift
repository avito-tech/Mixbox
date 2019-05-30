protocol PermissionInfo: class {
    func identifier() -> String
    func authorizationStatus() -> String
}
