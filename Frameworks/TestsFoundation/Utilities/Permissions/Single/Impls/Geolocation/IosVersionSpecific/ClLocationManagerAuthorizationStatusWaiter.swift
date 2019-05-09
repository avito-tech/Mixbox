import CoreLocation

final class ClLocationManagerAuthorizationStatusWaiter {
    func wait(authorizationStatus: CLAuthorizationStatus, bundleId: String) {
        for _ in 0..<5 where CLLocationManager.authorizationStatus(forBundleIdentifier: bundleId) == authorizationStatus {
            Thread.sleep(forTimeInterval: 1)
        }
    }
}
