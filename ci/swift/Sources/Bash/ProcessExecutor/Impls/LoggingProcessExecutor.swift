import Foundation

public final class LoggingProcessExecutor: ProcessExecutor {
    private let originalProcessExecutor: ProcessExecutor
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    
    public init(
        originalProcessExecutor: ProcessExecutor,
        bashEscapedCommandMaker: BashEscapedCommandMaker)
    {
        self.originalProcessExecutor = originalProcessExecutor
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
    }
    
    public func execute(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String],
        outputHandling: ProcessExecutorOutputHandling)
        throws
        -> ProcessResult
    {
        log(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        return try originalProcessExecutor.execute(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            outputHandling: outputHandling
        )
    }
    
    private func log(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String])
    {
        guard !arguments.isEmpty else {
            print("Called `execute` with empty arguments")
            return
        }
        
        let prettyPrintedCommand: String
        
        if arguments.starts(with: ["/bin/bash", "-l", "-c"]) && arguments.count == 4 {
            // Only print bash command. Note: relies on bash calles in this project.
            prettyPrintedCommand = arguments[3]
        } else {
            prettyPrintedCommand = bashEscapedCommandMaker.escapedCommand(
                arguments: arguments
            )
        }
        
        print(
            """
            Will execute:
            ```
            \(prettyPrintedCommand)
            ```
            """
        )
        
        print("inside directory: \(currentDirectory ?? FileManager.default.currentDirectoryPath)")
    }
}
