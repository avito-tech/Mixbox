import MixboxUiKit
import MixboxReporting

public final class GeolocationApplicationPermissionSetterFactoryImpl: GeolocationApplicationPermissionSetterFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider = CurrentApplicationCurrentSimulatorFileSystemRootProvider())
    {
        self.testFailureRecorder = testFailureRecorder
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
    }
    
    public func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter {
        if UIDevice.current.mb_iosVersion.majorVersion <= 11 {
            return IosFrom9To11GeolocationApplicationPermissionSetter(bundleId: bundleId)
        } else {
            return Ios12GeolocationApplicationPermissionSetter(
                bundleId: bundleId,
                currentSimulatorFileSystemRootProvider: currentSimulatorFileSystemRootProvider,
                testFailureRecorder: testFailureRecorder
            )
        }
    }
}
