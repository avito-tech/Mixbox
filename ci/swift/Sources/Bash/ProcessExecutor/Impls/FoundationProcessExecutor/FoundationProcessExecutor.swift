import Foundation
import CiFoundation

public final class FoundationProcessExecutor: ProcessExecutor {
    public init() {
    }
    
    public func execute(
        executable: String,
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String])
        -> ProcessResult
    {
        let process = Process(
            executable: executable,
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        process.execute()
        
        return process.result()
    }
}
