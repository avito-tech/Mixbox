import ResourceLocation
import Xcodebuild
import BuildArtifactsApple

public final class IosBuildArtifactsProviderImpl: IosBuildArtifactsProvider {
    private let xcodebuildResult: XcodebuildResult
    private let testDiscoveryMode: XcTestBundleTestDiscoveryMode
    
    public init(
        xcodebuildResult: XcodebuildResult,
        testDiscoveryMode: XcTestBundleTestDiscoveryMode
    ) {
        self.xcodebuildResult = xcodebuildResult
        self.testDiscoveryMode = testDiscoveryMode
    }
    
    public func iosLogicTests(
        testsTarget: String
    ) throws -> AppleBuildArtifacts {
        return try iosLogicTests(
            xctestBundlePath: xcodebuildResult.standaloneXctestBundlePath(
                testsTarget: testsTarget
            )
        )
    }
    
    public func iosApplicationTests(
        appName: String,
        testsTarget: String
    ) throws -> AppleBuildArtifacts {
        return try iosApplicationTests(
            xctestBundlePath: xcodebuildResult.bundledInApplicationXctestBundlePath(
                appName: appName,
                testsTarget: testsTarget
            ),
            appPath: xcodebuildResult.testedAppPath(
                appName: appName
            )
        )
    }
    
    public func iosUiTests(
        appName: String,
        testsTarget: String,
        additionalApps: [String]
    ) throws -> AppleBuildArtifacts {
        return try iosUiTests(
            xctestBundlePath: xcodebuildResult.uiTestXctestBundlePath(
                testsTarget: testsTarget
            ),
            runnerPath: xcodebuildResult.uiTestRunnerAppPath(
                testsTarget: testsTarget
            ),
            appPath: xcodebuildResult.testedAppPath(
                appName: appName
            ),
            additionalAppPaths: additionalApps.map {
                try xcodebuildResult.testedAppPath(appName: $0)
            }
        )
    }
    
    private func iosLogicTests(
        xctestBundlePath: String
    ) -> AppleBuildArtifacts {
        AppleBuildArtifacts(
            xcTestBundle: xcTestBundle(
                xctestBundlePath: xctestBundlePath
            ),
            testRunModeArtifacts: .logicTest
        )
    }
    
    private func iosApplicationTests(
        xctestBundlePath: String,
        appPath: String
    ) -> AppleBuildArtifacts {
        AppleBuildArtifacts(
            xcTestBundle: xcTestBundle(
                xctestBundlePath: xctestBundlePath
            ),
            testRunModeArtifacts: .applicationTest(
                appBundle(
                    appPath: appPath
                )
            )
        )
    }
    
    private func iosUiTests(
        xctestBundlePath: String,
        runnerPath: String,
        appPath: String,
        additionalAppPaths: [String]
    ) -> AppleBuildArtifacts {
        AppleBuildArtifacts(
            xcTestBundle: xcTestBundle(
                xctestBundlePath: xctestBundlePath
            ),
            testRunModeArtifacts: .uiTest(
                appBundle(
                    appPath: appPath
                ),
                runner(
                    runnerPath: runnerPath
                ),
                additionalApplicationBundles(
                    additionalAppPaths: additionalAppPaths
                )
            )
        )
    }
    
    private func appBundle(appPath: String) -> AppBundleLocation {
        AppBundleLocation(
            ResourceLocation.localFilePath(appPath)
        )
    }
    
    private func xcTestBundle(xctestBundlePath: String) -> XcTestBundle {
        XcTestBundle(
            location: TestBundleLocation(
                ResourceLocation.localFilePath(xctestBundlePath)
            ),
            testDiscoveryMode: testDiscoveryMode
        )
    }
    
    private func runner(runnerPath: String) -> RunnerAppLocation {
        RunnerAppLocation(
            ResourceLocation.localFilePath(runnerPath)
        )
    }
    
    private func additionalApplicationBundles(
        additionalAppPaths: [String]
    ) -> [AdditionalAppBundleLocation] {
        additionalAppPaths.map {
            AdditionalAppBundleLocation(
                ResourceLocation.localFilePath($0)
            )
        }
    }
}
