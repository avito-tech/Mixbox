import Bash
import Foundation
import CiFoundation

public final class BundledProcessExecutorImpl: BundledProcessExecutor {
    private let bashExecutor: BashExecutor
    private let gemfileLocationProvider: GemfileLocationProvider
    private let bundlerBashCommandGenerator: BundlerBashCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        gemfileLocationProvider: GemfileLocationProvider,
        bundlerBashCommandGenerator: BundlerBashCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.gemfileLocationProvider = gemfileLocationProvider
        self.bundlerBashCommandGenerator = bundlerBashCommandGenerator
    }
    
    public func execute(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String]?,
        shouldThrowOnNonzeroExitCode: Bool)
        throws
        -> ProcessResult
    {
        let result = try bashExecutor.executeOrThrow(
            command: bundlerBashCommandGenerator.bashCommandRunningCommandBundler(
                arguments: arguments
            ),
            currentDirectory: currentDirectory,
            environment: environment.map { .custom($0) } ?? .current,
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in },
            shouldThrowOnNonzeroExitCode: shouldThrowOnNonzeroExitCode
        )
        
        return ProcessResult(
            code: result.code,
            stdout: PlainProcessOutput(
                data: result.stdout.data
            ),
            stderr: PlainProcessOutput(
                data: result.stderr.data
            )
        )
    }
}
