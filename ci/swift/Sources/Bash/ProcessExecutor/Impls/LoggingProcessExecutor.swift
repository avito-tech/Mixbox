import Foundation

public final class LoggingProcessExecutor: ProcessExecutor {
    private let originalProcessExecutor: ProcessExecutor
    
    public init(originalProcessExecutor: ProcessExecutor) {
        self.originalProcessExecutor = originalProcessExecutor
    }
    
    public func execute(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String],
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
        throws
        -> ProcessResult
    {
        log(
            executable: executable,
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        return try originalProcessExecutor.execute(
            executable: executable,
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            stdoutDataHandler: stdoutDataHandler,
            stderrDataHandler: stderrDataHandler
        )
    }
    
    private func log(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String])
    {
        let prettyPrintedCommand: String
        
        if executable == "/bin/bash" && arguments.starts(with: ["-l", "-c"]) && arguments.count == 3 {
            prettyPrintedCommand = arguments[2]
        } else {
            let command = [executable] + arguments
            
            // ["a", "$b \"c\"", "`d`"] will be printed as this:
            // """
            // "a" "\$b \"c\"" "\`d\`"
            // """
            // not as this:
            // """
            // a b "c" `d`
            // """
            // and thus can be easily reproduced in bash.
            //
            // Potential improvement: do not put argument in quotes if it is not needed.
            // E.g.: "a b" should be inside quotes, but "a" should not.
            //
            prettyPrintedCommand = command
                // Escaping rules:
                // https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Double-Quotes
                .map { $0.replacingOccurrences(of: "\"", with: "\\\"") }
                .map { $0.replacingOccurrences(of: "!", with: "\\!") }
                .map { $0.replacingOccurrences(of: "`", with: "\\`") }
                .map { $0.replacingOccurrences(of: "$", with: "\\$") }
                .map { "\"\($0)\"" }
                .joined(separator: " ")
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
