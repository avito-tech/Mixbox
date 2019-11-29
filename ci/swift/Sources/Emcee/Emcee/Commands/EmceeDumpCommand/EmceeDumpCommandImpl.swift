import CiFoundation
import Foundation
import Models
import RuntimeDump

public final class EmceeDumpCommandImpl: EmceeDumpCommand {
    
    private let temporaryFileProvider: TemporaryFileProvider
    private let emceeExecutable: EmceeExecutable
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    private let jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader,
        jsonFileFromEncodableGenerator: JsonFileFromEncodableGenerator)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.emceeExecutable = emceeExecutable
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
        self.jsonFileFromEncodableGenerator = jsonFileFromEncodableGenerator
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
                    testsToRun: [],
                    buildArtifacts: BuildArtifacts(
                        appBundle: arguments.appPath.map { AppBundleLocation(try ResourceLocation.from($0)) },
                        runner: nil,
                        xcTestBundle: XcTestBundle(
                            location: TestBundleLocation(ResourceLocation.from(arguments.xctestBundle)),
                            runtimeDumpKind: arguments.appPath == nil ? .logicTest : .appTest
                        ),
                        additionalApplicationBundles: []
                    ),
                    environment: [:],
                    numberOfRetries: 5,
                    scheduleStrategy: .progressive,
                    testDestination: arguments.testDestinationConfigurations.first.unwrapOrThrow().testDestination,
                    testType: TestType.logicTest,
                    toolResources: ToolResources(
                        simulatorControlTool: .fbsimctl(FbsimctlLocation(ResourceLocation.from(arguments.fbsimctl))),
                        testRunnerTool: .fbxctest(FbxctestLocation(ResourceLocation.from(arguments.fbxctest)))
                    ),
                    toolchainConfiguration: ToolchainConfiguration(developerDir: .current)
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
