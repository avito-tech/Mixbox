import MixboxUiKit
import MixboxReporting

public final class GeolocationApplicationPermissionSetterFactoryImpl: GeolocationApplicationPermissionSetterFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    private let spinner: Spinner
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider,
        spinner: Spinner)
    {
        self.testFailureRecorder = testFailureRecorder
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
        self.spinner = spinner
    }
    
    public func geolocationApplicationPermissionSetter(bundleId: String) -> ApplicationPermissionSetter {
        if UIDevice.current.mb_iosVersion.majorVersion <= 11 {
            return IosFrom9To11GeolocationApplicationPermissionSetter(
                bundleId: bundleId,
                spinner: spinner
            )
        } else {
            return Ios12GeolocationApplicationPermissionSetter(
                bundleId: bundleId,
                currentSimulatorFileSystemRootProvider: currentSimulatorFileSystemRootProvider,
                testFailureRecorder: testFailureRecorder,
                spinner: spinner
            )
        }
    }
}
