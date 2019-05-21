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
