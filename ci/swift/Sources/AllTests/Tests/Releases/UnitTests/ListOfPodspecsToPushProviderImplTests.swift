import XCTest
import Releases
import TeamcityDi
import DI

public final class ListOfPodspecsToPushProviderImplTests: XCTestCase {
    // Test doesn't use mocks, uses everything real, and requires
    // updates every time dependencies change, however, it's easy to just copy-paste
    // desired output to test.
    // Test relies on fact that specs are ordered by name (if order is undefined otherwise; just to make it deterministic).
    func test() {
        assertDoesntThrow {
            let di = DiMaker<TeamcityBuildDependencies>.makeDi()
            
            let provider = try ListOfPodspecsToPushProviderImpl(
                bundledProcessExecutor: di.resolve(),
                repoRootProvider: di.resolve()
            )
            
            XCTAssertEqual(
                try provider.listOfPodspecsToPush().map { $0.name },
                // swiftlint:disable:next all
                ["Mixbox", "MixboxAnyCodable", "MixboxCocoaImageHashing", "MixboxDi", "MixboxFakeSettingsAppMain", "MixboxFoundation", "MixboxGenerators", "MixboxIoKit", "MixboxIpc", "MixboxIpcCommon", "MixboxLinkXCTAutomationSupport", "MixboxReflection", "MixboxSBTUITestTunnelCommon", "MixboxSBTUITestTunnelServer", "MixboxTestability", "MixboxUiKit", "MixboxBuiltinDi", "MixboxBuiltinIpc", "MixboxIpcSbtuiHost", "MixboxSBTUITestTunnelClient", "MixboxTestsFoundation", "MixboxUiTestsFoundation", "MixboxInAppServices", "MixboxIpcSbtuiClient", "MixboxMocksRuntime", "MixboxStubbing", "MixboxBlack", "MixboxGray"]
            )
        }
    }
}
