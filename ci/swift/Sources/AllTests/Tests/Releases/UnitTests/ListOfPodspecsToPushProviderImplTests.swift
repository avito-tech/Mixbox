import XCTest
import Releases
import TeamcityDi

public final class ListOfPodspecsToPushProviderImplTests: XCTestCase {
    // Test doesn't use mocks, uses everything real, and requires
    // updates every time dependencies change, however, it's easy to just copy-paste
    // desired output to test.
    // Test relies on fact that specs are ordered by name (if order is undefined otherwise; just to make it deterministic).
    func test() {
        assertDoesntThrow {
            let di = TeamcityBuildDi()
            try di.bootstrap(overrides: { _ in })
            let provider = ListOfPodspecsToPushProviderImpl(
                bundledProcessExecutor: try di.resolve(),
                repoRootProvider: try di.resolve()
            )
            
            XCTAssertEqual(
                try provider.listOfPodspecsToPush(),
                // swiftlint:disable:next all
                ["MixboxAnyCodable", "MixboxDi", "MixboxFakeSettingsAppMain", "MixboxFoundation", "MixboxGenerators", "MixboxIoKit", "MixboxIpc", "MixboxIpcCommon", "MixboxReflection", "MixboxSBTUITestTunnelCommon", "MixboxSBTUITestTunnelServer", "MixboxTestability", "MixboxUiKit", "MixboxBuiltinDi", "MixboxBuiltinIpc", "MixboxIpcSbtuiHost", "MixboxSBTUITestTunnelClient", "MixboxTestsFoundation", "MixboxUiTestsFoundation", "MixboxInAppServices", "MixboxIpcSbtuiClient", "MixboxMocksRuntime", "MixboxStubbing", "MixboxBlack", "MixboxGray"]
            )
        }
    }
}
