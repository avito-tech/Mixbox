import CiFoundation
import Foundation

public final class EmceeDumpCommandImpl: EmceeDumpCommand {
    
    private let temporaryFileProvider: TemporaryFileProvider
    private let emceeExecutable: EmceeExecutable
    private let runtimeDumpFileLoader: RuntimeDumpFileLoader
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        emceeExecutable: EmceeExecutable,
        runtimeDumpFileLoader: RuntimeDumpFileLoader)
    {
        self.temporaryFileProvider = temporaryFileProvider
        self.emceeExecutable = emceeExecutable
        self.runtimeDumpFileLoader = runtimeDumpFileLoader
    }
    
    public func dump(
        arguments: EmceeDumpCommandArguments)
        throws
        -> RuntimeDump
    {
        let output = temporaryFileProvider.temporaryFilePath()
        
        let staticArguments = [
            "--test-destinations", arguments.testDestinations,
            "--fbxctest", arguments.fbxctest,
            "--xctest-bundle", arguments.xctestBundle,
            "--output", output
        ]
        
        let optionalArguments = []
            + arguments.appPath.toArray { ["--app", $0] }
            + arguments.fbsimctl.toArray { ["--fbsimctl", $0] }
        
        try emceeExecutable.execute(
            command: "dump",
            arguments: staticArguments + optionalArguments
        )
        
        if !FileManager.default.fileExists(atPath: output, isDirectory: nil) {
            throw ErrorString("Failed to create runtime dump at \(output). See Emcee logs.")
        }
        
        return try runtimeDumpFileLoader.load(path: output)
    }
}
