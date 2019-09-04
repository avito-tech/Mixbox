import MixboxFoundation

public final class IosFrom9To11GeolocationApplicationPermissionSetter: ApplicationPermissionSetter {
    private let bundleId: String
    private let clLocationManagerAuthorizationStatusWaiter: ClLocationManagerAuthorizationStatusWaiter
    private let allowedDeniedNotDeterminedStateToClAuthorizationStatusConverter = AllowedDeniedNotDeterminedStateToClAuthorizationStatusConverter()
    
    public init(
        bundleId: String,
        waiter: RunLoopSpinningWaiter)
    {
        self.bundleId = bundleId
        self.clLocationManagerAuthorizationStatusWaiter = ClLocationManagerAuthorizationStatusWaiter(waiter: waiter)
    }
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        let authorizationStatus = allowedDeniedNotDeterminedStateToClAuthorizationStatusConverter
            .clAuthorizationStatus(state: state)
        
        CLLocationManager.setAuthorizationStatusByType(authorizationStatus, forBundleIdentifier: bundleId)
        
        CLLocationManager.shutdownDaemon()
        
        clLocationManagerAuthorizationStatusWaiter.wait(
            authorizationStatus: authorizationStatus,
            bundleId: bundleId
        )
    }
}
