import MixboxUiKit
import MixboxReporting

public final class GeolocationApplicationPermissionSetterFactoryImpl: GeolocationApplicationPermissionSetterFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    private let waiter: RunLoopSpinningWaiter
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider,
        waiter: RunLoopSpinningWaiter)
    {
        self.testFailureRecorder = testFailureRecorder
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
        self.waiter = waiter
    }
    
    public func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter {
        if UIDevice.current.mb_iosVersion.majorVersion <= 11 {
            return IosFrom9To11GeolocationApplicationPermissionSetter(
                bundleId: bundleId,
                waiter: waiter
            )
        } else {
            return Ios12GeolocationApplicationPermissionSetter(
                bundleId: bundleId,
                currentSimulatorFileSystemRootProvider: currentSimulatorFileSystemRootProvider,
                testFailureRecorder: testFailureRecorder,
                waiter: waiter
            )
        }
    }
}
