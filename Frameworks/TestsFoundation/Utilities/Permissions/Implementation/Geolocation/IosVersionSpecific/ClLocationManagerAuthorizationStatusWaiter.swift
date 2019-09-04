import CoreLocation

final class ClLocationManagerAuthorizationStatusWaiter {
    private let waiter: RunLoopSpinningWaiter
    
    init(waiter: RunLoopSpinningWaiter) {
        self.waiter = waiter
    }
    
    func wait(authorizationStatus: CLAuthorizationStatus, bundleId: String) {
        waiter.wait(
            timeout: 5,
            interval: 1,
            until: {
                let actualStatus = CLLocationManager.authorizationStatus(
                    forBundleIdentifier: bundleId
                )
                
                return actualStatus == authorizationStatus
            }
        )
    }
}
