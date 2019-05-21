import Foundation
import CiFoundation

public final class BashResult: CustomStringConvertible {
    public let code: Int
    public let stderr: BashOutput
    public let stdout: BashOutput
    
    public init(
        code: Int,
        stdout: BashOutput,
        stderr: BashOutput)
    {
        self.code = code
        self.stdout = stdout
        self.stderr = stderr
    }
    
    public convenience init(processResult: ProcessResult) {
        self.init(
            code: processResult.code,
            stdout: BashOutput(
                processOutput: processResult.stdout
            ),
            stderr: BashOutput(
                processOutput: processResult.stderr
            )
        )
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        return """
        Code: \(code)
        stdout: '\(debugString(stdout))'
        stderr: '\(debugString(stderr))'
        """
    }
    
    // MARK: - Private
    
    private func debugString(_ bashOutput: BashOutput) -> String {
        return bashOutput.trimmedUtf8String() ?? String(describing: bashOutput.data)
    }
}
