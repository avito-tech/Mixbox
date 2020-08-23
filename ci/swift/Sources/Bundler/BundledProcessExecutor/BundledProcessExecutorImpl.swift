import Bash
import Foundation
import CiFoundation

public final class BundledProcessExecutorImpl: BundledProcessExecutor {
    private let processExecutor: ProcessExecutor
    private let bundlerCommandGenerator: BundlerCommandGenerator
    private let temporaryFileProvider: TemporaryFileProvider
    private let environmentProvider: EnvironmentProvider
    
    public init(
        processExecutor: ProcessExecutor,
        bundlerCommandGenerator: BundlerCommandGenerator,
        temporaryFileProvider: TemporaryFileProvider,
        environmentProvider: EnvironmentProvider)
    {
        self.processExecutor = processExecutor
        self.bundlerCommandGenerator = bundlerCommandGenerator
        self.temporaryFileProvider = temporaryFileProvider
        self.environmentProvider = environmentProvider
    }
    
    public func execute(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String]?)
        throws
        -> ProcessResult
    {
        return try processExecutor.execute(
            arguments: bundle(arguments: arguments),
            currentDirectory: currentDirectory,
            environment: environment ?? environmentProvider.environment,
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
    }
    
    private func bundle(arguments: [String]) throws -> [String] {
        return try bundlerCommandGenerator.bundle(arguments: arguments)
    }
}
