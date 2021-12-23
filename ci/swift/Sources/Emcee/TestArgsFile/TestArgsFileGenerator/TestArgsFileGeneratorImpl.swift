import TestDiscovery
import Foundation
import CiFoundation
import Destinations
import TestArgFile
import BuildArtifacts
import ResourceLocation
import RunnerModels
import QueueModels
import SimulatorPoolModels
import TypedResourceLocation
import LoggingSetup
import WorkerCapabilitiesModels
import MetricsExtensions

public final class TestArgFileGeneratorImpl: TestArgFileGenerator {
    private let emceeProvider: EmceeProvider
    private let temporaryFileProvider: TemporaryFileProvider
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let emceeFileUploader: EmceeFileUploader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    private let simulatorSettingsProvider: SimulatorSettingsProvider
    private let developerDirProvider: DeveloperDirProvider
    private let simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider
    
    public init(
        emceeProvider: EmceeProvider,
        temporaryFileProvider: TemporaryFileProvider,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        emceeFileUploader: EmceeFileUploader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator,
        simulatorSettingsProvider: SimulatorSettingsProvider,
        developerDirProvider: DeveloperDirProvider,
        simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider)
    {
        self.emceeProvider = emceeProvider
        self.temporaryFileProvider = temporaryFileProvider
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.emceeFileUploader = emceeFileUploader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
        self.simulatorSettingsProvider = simulatorSettingsProvider
        self.developerDirProvider = developerDirProvider
        self.simulatorOperationTimeoutsProvider = simulatorOperationTimeoutsProvider
    }
    
    public func testArgFile(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> TestArgFile
    {
        let testDestinationConfigurations = try self.testDestinationConfigurations(arguments: arguments)
        
        return try testArgFile(
            testDestinationConfigurations: testDestinationConfigurations,
            testsToRun: testsToRun(
                runtimeDump: try runtimeDump(
                    arguments: arguments,
                    testDestinationConfigurations: testDestinationConfigurations
                )
            ),
            buildArtifacts: try buildArtifacts(arguments: arguments),
            environment: arguments.environment,
            testType: arguments.testType,
            priority: arguments.priority
        )
    }
    
    private func testDestinationConfigurations(
        arguments: TestArgFileGeneratorArguments)
        throws
    -> [TestDestinationConfiguration]
    {
        return try arguments.mixboxTestDestinationConfigurations.map {
            TestDestinationConfiguration(
                testDestination: try TestDestination(
                    deviceType: $0.testDestination.deviceType,
                    runtime: $0.testDestination.iOSVersion
                ),
                reportOutput: ReportOutput(
                    junit: $0.reportOutput.junit,
                    tracingReport: $0.reportOutput.tracingReport
                )
            )
        }
    }
    
    private func testArgFile(
        testDestinationConfigurations: [TestDestinationConfiguration],
        testsToRun: [TestToRun],
        buildArtifacts: BuildArtifacts,
        environment: [String: String],
        testType: TestType,
        priority: UInt)
        throws
        -> TestArgFile
    {
        return TestArgFile(
            entries: try testDestinationConfigurations.map { testDestinationConfiguration -> TestArgFileEntry in
                try TestArgFileEntry(
                    buildArtifacts: buildArtifacts,
                    developerDir: try developerDirProvider.developerDir(),
                    environment: environment,
                    numberOfRetries: 4,
                    pluginLocations: Set(),
                    scheduleStrategy: .progressive,
                    simulatorControlTool: SimulatorControlTool(
                        location: .insideUserLibrary,
                        tool: .simctl
                    ),
                    simulatorOperationTimeouts: simulatorOperationTimeoutsProvider.simulatorOperationTimeouts(),
                    simulatorSettings: simulatorSettingsProvider.simulatorSettings(),
                    testDestination: testDestinationConfiguration.testDestination,
                    testRunnerTool: .xcodebuild,
                    testTimeoutConfiguration: TestTimeoutConfiguration(
                        singleTestMaximumDuration: 420,
                        testRunnerMaximumSilenceDuration: 420
                    ),
                    testType: testType,
                    testsToRun: testsToRun,
                    workerCapabilityRequirements: []
                )
            },
            prioritizedJob: PrioritizedJob(
                analyticsConfiguration: AnalyticsConfiguration(),
                jobGroupId: JobGroupId(UUID().uuidString),
                jobGroupPriority: try Priority(intValue: priority),
                jobId: JobId(UUID().uuidString),
                jobPriority: try Priority(intValue: priority)
            ),
            testDestinationConfigurations: testDestinationConfigurations
        )
    }
    
    private func buildArtifacts(
        arguments: TestArgFileGeneratorArguments)
        throws
        -> BuildArtifacts
    {
        return BuildArtifacts(
            appBundle: try upload(path: arguments.appPath),
            runner: try uploadOptional(path: arguments.runnerPath),
            xcTestBundle: XcTestBundle(
                location: try upload(path: arguments.xctestBundlePath),
                testDiscoveryMode: arguments.testDiscoveryMode
            ),
            additionalApplicationBundles: try arguments.additionalAppPaths.map { additionalAppPath in
                try upload(path: additionalAppPath)
            }
        )
    }
    
    private func runtimeDump(
        arguments: TestArgFileGeneratorArguments,
        testDestinationConfigurations: [TestDestinationConfiguration])
        throws
        -> RuntimeDump
    {
        let emcee = try emceeProvider.emcee()
        
        let appPathDumpArgument: String?
        
        switch arguments.testDiscoveryMode {
        case .runtimeAppTest:
            appPathDumpArgument = arguments.appPath
        case .runtimeLogicTest:
            appPathDumpArgument = nil
        case .parseFunctionSymbols:
            appPathDumpArgument = nil
        case .runtimeExecutableLaunch:
            throw ErrorString("runtimeExecutableLaunch mode is not supported")
        }
        
        return try emcee.dump(
            arguments: EmceeDumpCommandArguments(
                jobId: UUID().uuidString,
                xctestBundle: arguments.xctestBundlePath,
                testDestinationConfigurations: testDestinationConfigurations,
                appPath: appPathDumpArgument,
                tempFolder: temporaryFileProvider.temporaryFilePath()
            )
        )
    }
    
    private func testsToRun(runtimeDump: RuntimeDump) -> [TestToRun] {
        return runtimeDump.discoveredTestEntries.flatMap { discoveredTestEntry in
            discoveredTestEntry.testMethods.map { testMethod in
                TestToRun.testName(
                    TestName(
                        className: discoveredTestEntry.className,
                        methodName: testMethod
                    )
                )
            }
        }
    }
    
    private func upload<T: ResourceLocationType>(
        path: String)
        throws
        -> TypedResourceLocation<T>
    {
        return TypedResourceLocation(
            ResourceLocation.remoteUrl(
                try emceeFileUploader.upload(path: path),
                nil
            )
        )
    }
    
    private func uploadOptional<T: ResourceLocationType>(
        path: String?)
        throws
        -> TypedResourceLocation<T>?
    {
        return try path.map(upload)
    }
}
