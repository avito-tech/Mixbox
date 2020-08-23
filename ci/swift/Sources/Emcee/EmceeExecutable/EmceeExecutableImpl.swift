import Bash
import CiFoundation
import Foundation

public final class EmceeExecutableImpl: EmceeExecutable {
    private let processExecutor: ProcessExecutor
    private let executablePath: String
    
    public init(
        processExecutor: ProcessExecutor,
        executablePath: String)
    {
        self.processExecutor = processExecutor
        self.executablePath = executablePath
    }
    
    public func execute(command: String, arguments: [String]) throws {
        let result = try processExecutor.execute(
            arguments: [executablePath, command] + arguments,
            currentDirectory: nil,
            environment: [:],
            stdoutDataHandler: { data in
                FileHandle.standardOutput.write(data)
            },
            stderrDataHandler: { data in
                FileHandle.standardError.write(data)
            }
        )
        
        if result.code != 0 {
            throw ErrorString(
                """
                Emcee failed to execute command "\(command)" with exit code \(result.code)"
                """
            )
        }
    }
}
