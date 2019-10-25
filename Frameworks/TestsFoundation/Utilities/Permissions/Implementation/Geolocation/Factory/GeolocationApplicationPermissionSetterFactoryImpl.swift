import MixboxUiKit
import MixboxTestsFoundation

public final class GeolocationApplicationPermissionSetterFactoryImpl: GeolocationApplicationPermissionSetterFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    private let waiter: RunLoopSpinningWaiter
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider,
        waiter: RunLoopSpinningWaiter,
        iosVersionProvider: IosVersionProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
        self.waiter = waiter
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter {
        if iosVersionProvider.iosVersion().majorVersion <= 11 {
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
