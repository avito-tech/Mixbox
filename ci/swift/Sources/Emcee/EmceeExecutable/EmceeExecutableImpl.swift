import Bash
import CiFoundation
import Foundation

public final class EmceeExecutableImpl: EmceeExecutable {
    private let processExecutor: ProcessExecutor
    private let executablePath: String
    private let ciLogger: CiLogger
    
    public init(
        processExecutor: ProcessExecutor,
        executablePath: String,
        ciLogger: CiLogger
    ) {
        self.processExecutor = processExecutor
        self.executablePath = executablePath
        self.ciLogger = ciLogger
    }
    
    public func execute(command: String, arguments: [String]) throws {
        try ciLogger.logBlock(name: "Executing Emcee command \(command)") {
            _ = try processExecutor.executeOrThrow(
                arguments: [executablePath, command] + arguments,
                currentDirectory: nil,
                environment: [:],
                outputHandling: .bypass
            )
        }
    }
}
