import Models
import TestDiscovery
import Foundation
import Destinations
import BuildArtifacts

// NOTE: Tightly coupled with Mixbox CI and can hardly be reused for other projects.
public final class TestArgFileGeneratorArguments {
    public let runnerPath: String?
    public let appPath: String
    public let additionalAppPaths: [String]
    public let xctestBundlePath: String
    public let mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration]
    public let environment: [String: String]
    public let testType: TestType
    public let testDiscoveryMode: XcTestBundleTestDiscoveryMode
    public let priority: UInt
    
    public init(
        runnerPath: String?,
        appPath: String,
        additionalAppPaths: [String],
        xctestBundlePath: String,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        environment: [String: String],
        testType: TestType,
        testDiscoveryMode: XcTestBundleTestDiscoveryMode,
        priority: UInt)
    {
        self.runnerPath = runnerPath
        self.appPath = appPath
        self.additionalAppPaths = additionalAppPaths
        self.xctestBundlePath = xctestBundlePath
        self.mixboxTestDestinationConfigurations = mixboxTestDestinationConfigurations
        self.environment = environment
        self.testType = testType
        self.testDiscoveryMode = testDiscoveryMode
        self.priority = priority
    }
}
