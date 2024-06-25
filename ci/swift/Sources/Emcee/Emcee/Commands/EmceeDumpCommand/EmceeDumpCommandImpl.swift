import CiFoundation
import Foundation
import TestArgFile
import TestDiscovery
import ResourceLocation
import SimulatorPoolModels
import RunnerModels
import QueueModels
import SingletonHell
import WorkerCapabilitiesModels
import MetricsExtensions
import ScheduleStrategy
import CommonTestModels

public final class EmceeDumpCommandImpl: EmceeDumpCommand {
    private let temporaryFileProvider: TemporaryFileProvider
    private let emceeExecutable: EmceeExecutable
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    private let simulatorSettingsProvider: SimulatorSettingsProvider
    private let developerDirProvider: DeveloperDirProvider
    private let remoteCacheConfigProvider: RemoteCacheConfigProvider
    private let simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider
    private let environmentProvider: EnvironmentProvider
    private let emceeVersionProvider: EmceeVersionProvider
    private let retrier: Retrier
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator,
        simulatorSettingsProvider: SimulatorSettingsProvider,
        developerDirProvider: DeveloperDirProvider,
        remoteCacheConfigProvider: RemoteCacheConfigProvider,
        simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider,
        environmentProvider: EnvironmentProvider,
        emceeVersionProvider: EmceeVersionProvider,
        retrier: Retrier)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.emceeExecutable = emceeExecutable
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
        self.simulatorSettingsProvider = simulatorSettingsProvider
        self.developerDirProvider = developerDirProvider
        self.remoteCacheConfigProvider = remoteCacheConfigProvider
        self.simulatorOperationTimeoutsProvider = simulatorOperationTimeoutsProvider
        self.environmentProvider = environmentProvider
        self.emceeVersionProvider = emceeVersionProvider
        self.retrier = retrier
    }
    
    public func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
    {
        do {
            let jsonPath = try retrier.retry(retries: 3) {
                try generateFile { jsonPath in
                    try emceeExecutable.execute(
                        command: "dump",
                        arguments: asStrings(arguments: arguments, jsonPath: jsonPath)
                    )
                }
            }
            
            // I don't know why it is 2d array.
            let entries: [[DiscoveredTestEntry]] = try decodableFromJsonFileLoader.load(path: jsonPath)
            
            if entries.count != 1 {
                throw ErrorString("Unexpected length of array in runtime dump file: \(entries.count), expected 1")
            }
            
            if environmentProvider.get(env: Env.MIXBOX_CI_RUN_ONLY_ONE_TEST) == "true" {
                return RuntimeDump(
                    discoveredTestEntries: [try entries.first.unwrapOrThrow().first.unwrapOrThrow()]
                )
            } else {
                return RuntimeDump(
                    discoveredTestEntries: try entries.first.unwrapOrThrow()
                )
            }
        } catch {
            throw ErrorString("Failed to perform runtime dump: \(error)")
        }
    }
    
    private func generateFile(using body: (String) throws -> ()) throws -> String {
        let jsonPath = temporaryFileProvider.temporaryFilePath()
        
        try body(jsonPath)
        
        if !FileManager.default.fileExists(atPath: jsonPath, isDirectory: nil) {
            throw ErrorString("Failed to create runtime dump at \(jsonPath). See Emcee logs.")
        }
        
        return jsonPath
    }
    
    private func asStrings(arguments: EmceeDumpCommandArguments, jsonPath: String) throws -> [String] {
        let testArgFile = TestArgFile<AppleTestArgFileEntry>(
            entries: [
                try AppleTestArgFileEntry(
                    bundleId: nil,
                    appleBuildArtifacts: arguments.iosBuildArtifacts,
                    developerDir: try developerDirProvider.developerDir(),
                    environment: [:],
                    userInsertedLibraries: [],
                    numberOfRetries: 5,
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
                    testDestination: arguments.testDestinationConfigurations.first.unwrapOrThrow().testDestination,
                    testMaximumDuration: 420,
                    testRunnerMaximumSilenceDuration: 420,
                    testAttachmentLifetime: .keepNever,
                    testsToRun: [],
                    workerCapabilityRequirements: []
                )
            ],
            prioritizedJob: PrioritizedJob(
                analyticsConfiguration: AnalyticsConfiguration(),
                jobGroupId: JobGroupId(UUID().uuidString),
                jobGroupPriority: Priority.medium,
                jobId: JobId(UUID().uuidString),
                jobPriority: Priority.medium
            ),
            testDestinationConfigurations: arguments.testDestinationConfigurations,
            allowQueueToTrackJobGeneratorAliveness: true
        )
        
        let staticArguments = [
            "--test-arg-file", try jsonFileFromEncodableGenerator.generateJsonFile(encodable: testArgFile),
            "--temp-folder", arguments.tempFolder,
            "--output", jsonPath,
            "--remote-cache-config", try remoteCacheConfigProvider.remoteCacheConfigJsonFilePath()
        ]
        
        return staticArguments
    }
}
