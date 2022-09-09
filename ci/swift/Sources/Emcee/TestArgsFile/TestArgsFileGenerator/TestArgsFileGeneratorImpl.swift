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
import WorkerCapabilitiesModels
import MetricsExtensions
import ScheduleStrategy
import CommonTestModels
import TestDestination

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
        -> TestArgFile<AppleTestArgFileEntry>
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
            iosBuildArtifacts: arguments.iosBuildArtifacts,
            environment: arguments.environment,
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
                testDestination: TestDestination()
                    .add(
                        key: AppleTestDestinationFields.simDeviceType,
                        value: $0.testDestination.deviceTypeId
                    )
                    .add(
                        key: AppleTestDestinationFields.simRuntime,
                        value: $0.testDestination.runtimeId
                    ),
                reportOutput: ReportOutput(
                    junit: $0.reportOutput.junit,
                    tracingReport: $0.reportOutput.tracingReport,
                    resultBundle: nil
                )
            )
        }
    }
    
    private func testArgFile(
        testDestinationConfigurations: [TestDestinationConfiguration],
        testsToRun: [TestToRun],
        iosBuildArtifacts: AppleBuildArtifacts,
        environment: [String: String],
        priority: UInt)
        throws
        -> TestArgFile<AppleTestArgFileEntry>
    {
        return TestArgFile(
            entries: try testDestinationConfigurations.map { testDestinationConfiguration -> AppleTestArgFileEntry in
                try AppleTestArgFileEntry(
                    buildArtifacts: iosBuildArtifacts,
                    developerDir: try developerDirProvider.developerDir(),
                    environment: environment,
                    userInsertedLibraries: [],
                    numberOfRetries: 4,
                    testRetryMode: .retryThroughQueue,
                    logCapturingMode: .noLogs,
                    runnerWasteCleanupPolicy: .clean,
                    pluginLocations: [],
                    scheduleStrategy: ScheduleStrategy(
                        testSplitterType: .progressive
                    ),
                    simulatorOperationTimeouts: simulatorOperationTimeoutsProvider.simulatorOperationTimeouts(),
                    simulatorSettings: simulatorSettingsProvider.simulatorSettings(),
                    testDestination: testDestinationConfiguration.testDestination,
                    testTimeoutConfiguration: TestTimeoutConfiguration(
                        singleTestMaximumDuration: 420,
                        testRunnerMaximumSilenceDuration: 420
                    ),
                    testAttachmentLifetime: .keepNever,
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
            testDestinationConfigurations: testDestinationConfigurations,
            allowQueueToTrackJobGeneratorAliveness: true
        )
    }
    
    private func runtimeDump(
        arguments: TestArgFileGeneratorArguments,
        testDestinationConfigurations: [TestDestinationConfiguration])
        throws
        -> RuntimeDump
    {
        let emcee = try emceeProvider.emcee()
        
        return try emcee.dump(
            arguments: EmceeDumpCommandArguments(
                jobId: UUID().uuidString,
                iosBuildArtifacts: arguments.iosBuildArtifacts,
                testDestinationConfigurations: testDestinationConfigurations,
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
