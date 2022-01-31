import CiFoundation

public final class ProcessResult {
    public let code: Int
    public let stderr: ProcessOutput
    public let stdout: ProcessOutput
    
    public init(
        code: Int,
        stdout: ProcessOutput,
        stderr: ProcessOutput)
    {
        self.code = code
        self.stdout = stdout
        self.stderr = stderr
    }
}

extension ProcessResult {
    // `arguments`: parameters passed to `execute` of ProcessExecutor,
    // to form an error message
    public func throwErrorOnNonZeroExitCode(
        arguments: [String]
    ) throws {
        if code != 0 {
            let argumentsAsString = arguments.joined(separator: " ")
            throw ErrorString(
                """
                Failed to execute "\(argumentsAsString)" with exit code \(code)
                Stderr:
                \(stderr.utf8String() ?? "")
                Stdout:
                \(stdout.utf8String() ?? "")
                """
            )
        }
    }
}
