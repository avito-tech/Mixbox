import Foundation
import CiFoundation

public protocol BashExecutor {
    func execute(
        command: String,
        currentDirectory: String?,
        environment: [String: String]?)
        -> BashResult
}

extension BashExecutor {
    public func executeOrThrow(
        command: String,
        currentDirectory: String? = nil,
        environment: [String: String]? = nil)
        throws
        -> BashResult
    {
        let bashResult = execute(
            command: command,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        if bashResult.code != 0 {
            throw NonZeroExitCodeBashError(
                bashResult: bashResult
            )
        } else {
            return bashResult
        }
    }
    
    // Matches this behavior in bash:
    // ```
    // local output=$(ls /path)
    // ```
    public func executeAndReturnTrimmedOutputOrThrow(
        command: String,
        currentDirectory: String? = nil,
        environment: [String: String]? = nil)
        throws
        -> String
    {
        let bashResult = execute(
            command: command,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        if bashResult.code != 0 {
            throw NonZeroExitCodeBashError(
                bashResult: bashResult
            )
        } else {
            return try bashResult.stdout.trimmedUtf8String().unwrapOrThrow()
        }
    }
}
