public protocol ApplicationPermissionsSetterFactory: AnyObject {
    func applicationPermissionsSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionsSetter
}
