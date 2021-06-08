public protocol TccDbApplicationPermissionSetterFactory: AnyObject {
    func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String)
        -> ApplicationPermissionSetter
}
