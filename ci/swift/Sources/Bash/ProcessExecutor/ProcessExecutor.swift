import Foundation
import CiFoundation

public protocol ProcessExecutor: AnyObject {
    func execute(
        // Example: ["/bin/ls", "-a"]
        arguments: [String],
        // Example: "/tmp". If nil is passed, current directory will not be changed.
        currentDirectory: String?,
        // Example: ["PATH": "/bin"]
        // Note: you can use EnvironmentProvider to get environment.
        environment: [String: String],
        outputHandling: ProcessExecutorOutputHandling
    ) throws -> ProcessResult
}

extension ProcessExecutor {
    public func executeOrThrow(
        arguments: [String],
        currentDirectory: String? = nil,
        environment: [String: String],
        outputHandling: ProcessExecutorOutputHandling
    ) throws -> ProcessResult {
        let result = try execute(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            outputHandling: outputHandling
        )
        
        try result.throwErrorOnNonZeroExitCode(arguments: arguments)
        
        return result
    }
    
    public func executeOrThrow(
        arguments: [String],
        currentDirectory: String? = nil,
        environmentProvider: EnvironmentProvider,
        outputHandling: ProcessExecutorOutputHandling
    ) throws -> ProcessResult {
        try executeOrThrow(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environmentProvider.environment,
            outputHandling: outputHandling
        )
    }
}
