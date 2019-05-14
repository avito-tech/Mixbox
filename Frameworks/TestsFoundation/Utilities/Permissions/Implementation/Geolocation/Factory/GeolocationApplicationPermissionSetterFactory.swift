import MixboxFoundation

public protocol GeolocationApplicationPermissionSetterFactory {
    func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter
}
