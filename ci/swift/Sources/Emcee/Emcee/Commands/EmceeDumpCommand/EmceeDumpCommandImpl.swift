import CiFoundation
import Foundation
import Models
import RuntimeDump

public final class EmceeDumpCommandImpl: EmceeDumpCommand {
    private let temporaryFileProvider: TemporaryFileProvider
    private let emceeExecutable: EmceeExecutable
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    private let simulatorSettingsProvider: SimulatorSettingsProvider
    private let toolchainConfigurationProvider: ToolchainConfigurationProvider
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator,
        simulatorSettingsProvider: SimulatorSettingsProvider,
        toolchainConfigurationProvider: ToolchainConfigurationProvider)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.emceeExecutable = emceeExecutable
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
        self.simulatorSettingsProvider = simulatorSettingsProvider
        self.toolchainConfigurationProvider = toolchainConfigurationProvider
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
            
            return RuntimeDump(
                runtimeTestEntries: try entries.first.unwrapOrThrow()
            )
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
                    environment: [:],
                    numberOfRetries: 5,
                    scheduleStrategy: .progressive,
                    simulatorSettings: simulatorSettingsProvider.simulatorSettings(),
                    testDestination: arguments.testDestinationConfigurations.first.unwrapOrThrow().testDestination,
                    testTimeoutConfiguration: TestTimeoutConfiguration(
                        singleTestMaximumDuration: 420,
                        testRunnerMaximumSilenceDuration: 420
                    ),
                    testType: TestType.logicTest,
                    testsToRun: [],
                    toolResources: ToolResources(
                        simulatorControlTool: .fbsimctl(FbsimctlLocation(ResourceLocation.from(arguments.fbsimctl))),
                        testRunnerTool: .fbxctest(FbxctestLocation(ResourceLocation.from(arguments.fbxctest)))
                    ),
                    toolchainConfiguration: try toolchainConfigurationProvider.toolchainConfiguration()
                )
            ],
            priority: Priority.medium,
            testDestinationConfigurations: arguments.testDestinationConfigurations
        )
        
        let staticArguments = [
            "--test-arg-file", try jsonFileFromEncodableGenerator.generateJsonFile(encodable: testArgFile),
            "--temp-folder", arguments.tempFolder,
            "--output", jsonPath
        ]
        
        return staticArguments
    }
}
