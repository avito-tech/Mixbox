import Foundation
import CiFoundation

public final class FoundationProcessExecutor: ProcessExecutor {
    public init() {
    }
    
    public func execute(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String],
        outputHandling: ProcessExecutorOutputHandling)
        throws
        -> ProcessResult
    {
        guard let executable = arguments.first else {
            throw ErrorString(
                """
                Can't execute process. Arguments count: \(arguments.count). Expected at least 1 arugment (executable).
                """
            )
        }
        
        let arguments = Array(arguments.dropFirst())
        
        guard FileManager.default.fileExists(atPath: executable, isDirectory: nil) else {
            throw ErrorString(
                """
                Could not execute process. File doesn't exist: "\(executable)"
                """
            )
        }
        
        guard FileManager.default.isExecutableFile(atPath: executable) else {
            throw ErrorString(
                """
                Could not execute process. File exists, but is not executable: "\(executable)"
                """
            )
        }
        
        let process = Process(
            executable: executable,
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            stdoutDataHandler: outputHandling.stdoutDataHandler,
            stderrDataHandler: outputHandling.stderrDataHandler
        )
        
        process.execute()
        
        return process.result()
    }
}
