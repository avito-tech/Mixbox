import CiFoundation
import Foundation
import Models
import RuntimeDump
import TestArgFile
import BuildArtifacts
import ResourceLocation
import SimulatorPoolModels
import RunnerModels
import QueueModels
import SingletonHell

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
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator,
        simulatorSettingsProvider: SimulatorSettingsProvider,
        developerDirProvider: DeveloperDirProvider,
        remoteCacheConfigProvider: RemoteCacheConfigProvider,
        simulatorOperationTimeoutsProvider: SimulatorOperationTimeoutsProvider,
        environmentProvider: EnvironmentProvider)
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
    }
    
    public func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
    {
        do {
            let jsonPath = try generateFile { jsonPath in
                try emceeExecutable.execute(
                    command: "dump",
                    arguments: asStrings(arguments: arguments, jsonPath: jsonPath)
                )
            }
            
            // I don't know why it is 2d array.
            let entries: [[RuntimeTestEntry]] = try decodableFromJsonFileLoader.load(path: jsonPath)
            
            if entries.count != 1 {
                throw ErrorString("Unexpected length of array in runtime dump file: \(entries.count), expected 1")
            }
            
            if environmentProvider.get(env: Env.MIXBOX_CI_RUN_ONLY_ONE_TEST) == "true" {
                return RuntimeDump(
                    runtimeTestEntries: [try entries.first.unwrapOrThrow().first.unwrapOrThrow()]
                )
            } else {
                return RuntimeDump(
                    runtimeTestEntries: try entries.first.unwrapOrThrow()
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
        let testArgFile = TestArgFile(
            entries: [
                try TestArgFile.Entry(
                    buildArtifacts: BuildArtifacts(
                        appBundle: arguments.appPath.map {
                            AppBundleLocation(try ResourceLocation.from($0))
                        },
                        runner: nil,
                        xcTestBundle: XcTestBundle(
                            location: TestBundleLocation(ResourceLocation.from(arguments.xctestBundle)),
                            runtimeDumpKind: arguments.appPath == nil ? .logicTest : .appTest
                        ),
                        additionalApplicationBundles: [] as [AdditionalAppBundleLocation]
                    ),
                    developerDir: try developerDirProvider.developerDir(),
                    environment: [:],
                    numberOfRetries: 5,
                    pluginLocations: Set(),
                    scheduleStrategy: .progressive,
                    simulatorControlTool: .fbsimctl(FbsimctlLocation(ResourceLocation.from(arguments.fbsimctl))),
                    simulatorOperationTimeouts: simulatorOperationTimeoutsProvider.simulatorOperationTimeouts(),
                    simulatorSettings: simulatorSettingsProvider.simulatorSettings(),
                    testDestination: arguments.testDestinationConfigurations.first.unwrapOrThrow().testDestination,
                    testRunnerTool: .fbxctest(FbxctestLocation(ResourceLocation.from(arguments.fbxctest))),
                    testTimeoutConfiguration: TestTimeoutConfiguration(
                        singleTestMaximumDuration: 420,
                        testRunnerMaximumSilenceDuration: 420
                    ),
                    testType: TestType.logicTest,
                    testsToRun: []
                )
            ],
            priority: .medium,
            testDestinationConfigurations: arguments.testDestinationConfigurations
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
