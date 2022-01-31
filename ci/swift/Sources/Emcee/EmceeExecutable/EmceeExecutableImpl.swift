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
        _ = try processExecutor.executeOrThrow(
            arguments: [executablePath, command] + arguments,
            currentDirectory: nil,
            environment: [:],
            outputHandling: .bypass
        )
    }
}
