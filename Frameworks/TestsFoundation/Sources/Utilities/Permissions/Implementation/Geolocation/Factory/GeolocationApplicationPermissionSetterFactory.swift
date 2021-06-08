import MixboxFoundation

public protocol GeolocationApplicationPermissionSetterFactory: AnyObject {
    func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter
}
