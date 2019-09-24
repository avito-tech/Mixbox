import CiFoundation
import Foundation

public final class EmceeDumpCommandImpl: EmceeDumpCommand {
    
    private let temporaryFileProvider: TemporaryFileProvider
    private let emceeExecutable: EmceeExecutable
    private let decodableFromJsonFileLoader: DecodableFromJsonFileLoader
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        decodableFromJsonFileLoader: DecodableFromJsonFileLoader)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.emceeExecutable = emceeExecutable
        self.decodableFromJsonFileLoader = decodableFromJsonFileLoader
    }
    
    public func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
    {
        let jsonPath = try generateFile { jsonPath in
            try emceeExecutable.execute(
                command: "dump",
                arguments: asStrings(arguments: arguments, jsonPath: jsonPath)
            )
        }
        
        return RuntimeDump(
            runtimeTestEntries: try decodableFromJsonFileLoader.load(path: jsonPath)
        )
    }
    
    private func generateFile(using body: (String) throws -> ()) throws -> String {
        let jsonPath = temporaryFileProvider.temporaryFilePath()
        
        try body(jsonPath)
        
        if !FileManager.default.fileExists(atPath: jsonPath, isDirectory: nil) {
            throw ErrorString("Failed to create runtime dump at \(jsonPath). See Emcee logs.")
        }
        
        return jsonPath
    }
    
    private func asStrings(arguments: EmceeDumpCommandArguments, jsonPath: String) -> [String] {
        let staticArguments = [
            "--test-destinations", arguments.testDestinations,
            "--fbxctest", arguments.fbxctest,
            "--xctest-bundle", arguments.xctestBundle,
            "--temp-folder", arguments.tempFolder,
            "--output", jsonPath
        ]
        
        let optionalArguments = []
            + arguments.appPath.toArray { ["--app", $0] }
            + arguments.fbsimctl.toArray { ["--fbsimctl", $0] }
        
        return staticArguments + optionalArguments
    }
}
