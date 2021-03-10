import MixboxFoundation

public protocol GeolocationApplicationPermissionSetterFactory: class {
    func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter
}
