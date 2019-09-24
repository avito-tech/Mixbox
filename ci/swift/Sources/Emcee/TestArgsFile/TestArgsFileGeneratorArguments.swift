import Models
import RuntimeDump
import Foundation
import Destinations

// NOTE: Tightly coupled with Mixbox CI and can hardly be reused for other projects.
public final class TestArgFileGeneratorArguments {
    public let runnerPath: String?
    public let appPath: String
    public let additionalAppPaths: [String]
    public let xctestBundlePath: String
    public let fbsimctlUrl: URL?
    public let fbxctestUrl: URL
    public let mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration]
    public let environment: [String: String]
    public let testType: TestType
    public let runtimeDumpKind: RuntimeDumpKind
    public let priority: UInt
    
    public init(
        runnerPath: String?,
        appPath: String,
        additionalAppPaths: [String],
        xctestBundlePath: String,
        fbsimctlUrl: URL?,
        fbxctestUrl: URL,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        environment: [String: String],
        testType: TestType,
        runtimeDumpKind: RuntimeDumpKind,
        priority: UInt)
    {
        self.runnerPath = runnerPath
        self.appPath = appPath
        self.additionalAppPaths = additionalAppPaths
        self.xctestBundlePath = xctestBundlePath
        self.fbsimctlUrl = fbsimctlUrl
        self.fbxctestUrl = fbxctestUrl
        self.mixboxTestDestinationConfigurations = mixboxTestDestinationConfigurations
        self.environment = environment
        self.testType = testType
        self.runtimeDumpKind = runtimeDumpKind
        self.priority = priority
    }
}
