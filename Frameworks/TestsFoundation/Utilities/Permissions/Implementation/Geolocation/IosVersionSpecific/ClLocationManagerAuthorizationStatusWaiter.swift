import CoreLocation

final class ClLocationManagerAuthorizationStatusWaiter {
    private let spinner: Spinner
    
    init(spinner: Spinner) {
        self.spinner = spinner
    }
    
    func wait(authorizationStatus: CLAuthorizationStatus, bundleId: String) {
        spinner.spin(
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
