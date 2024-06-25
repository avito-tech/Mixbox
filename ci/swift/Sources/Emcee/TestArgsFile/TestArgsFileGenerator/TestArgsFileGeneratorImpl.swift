import TestDiscovery
import Foundation
import CiFoundation
import Destinations
import TestArgFile
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
import BuildArtifactsApple
import EmceeTypes
import RequestSenderModels

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
        let testDestinationConfigurations = self.testDestinationConfigurations(arguments: arguments)
        
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
        arguments: TestArgFileGeneratorArguments
    ) -> [TestDestinationConfiguration] {
        return arguments.mixboxTestDestinationConfigurations.map {
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
                reportOutput: $0.reportOutput
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
        var stableTestsToRun = [TestToRun]()
        var flakyTestsToRun = [TestToRun]()
        
        testsToRun.forEach { testToRun in
            switch testToRun {
            case .testName(let testName):
                if testName.methodName.contains("_FLAKY") {
                    flakyTestsToRun.append(testToRun)
                } else {
                    stableTestsToRun.append(testToRun)
                }
            case .allDiscoveredTests:
                stableTestsToRun.append(testToRun)
            case .allTestsInClass(className: let className):
                if className.contains("_FLAKY") {
                    flakyTestsToRun.append(testToRun)
                } else {
                    stableTestsToRun.append(testToRun)
                }
            }
        }
        
        return TestArgFile(
            entries: try testDestinationConfigurations.flatMap { testDestinationConfiguration in
                try [
                    appleTestArgFileEntry(
                        testsToRun: stableTestsToRun,
                        testDestinationConfiguration: testDestinationConfiguration,
                        iosBuildArtifacts: iosBuildArtifacts,
                        environment: environment,
                        numberOfRetries: 4
                    ),
                    appleTestArgFileEntry(
                        testsToRun: flakyTestsToRun,
                        testDestinationConfiguration: testDestinationConfiguration,
                        iosBuildArtifacts: iosBuildArtifacts,
                        environment: environment,
                        numberOfRetries: 8
                    )
                ]
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
    
    private func appleTestArgFileEntry(
        testsToRun: [TestToRun],
        testDestinationConfiguration: TestDestinationConfiguration,
        iosBuildArtifacts: AppleBuildArtifacts,
        environment: [String: String],
        numberOfRetries: UInt
    ) throws -> AppleTestArgFileEntry {
        try AppleTestArgFileEntry(
            bundleId: nil,
            appleBuildArtifacts: iosBuildArtifacts,
            developerDir: try developerDirProvider.developerDir(),
            environment: environment,
            userInsertedLibraries: [],
            numberOfRetries: numberOfRetries,
            testRetryMode: .retryThroughQueue,
            logCapturingMode: .noLogs,
            preferredScreenCaptureFormat: .screenshots,
            runnerWasteCleanupPolicy: .clean,
            proxySettings: nil,
            pluginLocations: [],
            pluginTeardownTimeout: 60,
            scheduleStrategy: ScheduleStrategy(
                testSplitterType: .progressive
            ),
            simulatorOperationTimeouts: simulatorOperationTimeoutsProvider.simulatorOperationTimeouts(),
            simulatorSettings: simulatorSettingsProvider.simulatorSettings(),
            testDestination: testDestinationConfiguration.testDestination,
            testMaximumDuration: 420,
            testRunnerMaximumSilenceDuration: 420,
            testAttachmentLifetime: .keepNever,
            testsToRun: testsToRun,
            workerCapabilityRequirements: [
                WorkerCapabilityRequirement(
                    capabilityName: "emcee.cpu.architecture",
                    constraint: .equal("arm64")
                )
            ]
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
        path: String
    ) throws -> TypedResourceLocation<T> {
        return TypedResourceLocation(
            ResourceLocation.remoteUrl(
                try NetworkLocationURL(
                    url: try emceeFileUploader.upload(
                        path: path
                    )
                ),
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
