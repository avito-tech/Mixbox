import Foundation
import CiFoundation

public protocol BashExecutor {
    func execute(
        command: String,
        currentDirectory: String?,
        environment: BashExecutorEnvironment,
        stdoutDataHandler: @escaping (Data) -> (),
        stderrDataHandler: @escaping (Data) -> ())
        throws
        -> BashResult
}

extension BashExecutor {
    // Q: @tssolonin: It is not obvious when the function named `executeOrThrow` throws error.
    // Maybe to name it `executeWithSuccess` or make an `extension` to `BashResult` with `success() throws -> BashResult`?
    // A: @arazinov: it will look bad:
    // ```
    // let checksum = bashExecutor.executeAndReturnTrimmedOutputOrThrow(
    //     command:
    //     """
    //     find "\(file)" -type f -print0 \
    //     | sort -z \
    //     | xargs -0 shasum \
    //     | shasum \
    //     | grep -oE "^\\S+"
    //     """,
    //     currentDirectory: projectDirectory
    // )
    // ```
    // vs
    // ```
    // let checksum = bashExecutor.execute(
    //     command:
    //     """
    //     find "\(file)" -type f -print0 \
    //     | sort -z \
    //     | xargs -0 shasum \
    //     | shasum \
    //     | grep -oE "^\\S+"
    //     """,
    //     currentDirectory: projectDirectory
    // ).throwForNonZeroExitCode().stdout.trimmedUtf8StringOrThrow()
    // ```
    // which will be auto-indented as:
    // ```
    // let checksum = bashExecutor.execute(
    //     command:
    //     """
    //     find "\(file)" -type f -print0 \
    //     | sort -z \
    //     | xargs -0 shasum \
    //     | shasum \
    //     | grep -oE "^\\S+"
    //     """,
    //     currentDirectory: projectDirectory
    //     ).throwForNonZeroExitCode().stdout.trimmedUtf8StringOrThrow()
    // ```
    // which I can not stand, or it will require to write more code:
    // ```
    // let checksumBashResult = bashExecutor.execute(
    //     command:
    //     """
    //     find "\(file)" -type f -print0 \
    //     | sort -z \
    //     | xargs -0 shasum \
    //     | shasum \
    //     | grep -oE "^\\S+"
    //     """,
    //     currentDirectory: projectDirectory
    // )
    // let checksum = try rmRfCocoapodsBashResult.throwForNonZeroExitCode().stdout.trimmedUtf8StringOrThrow()
    // ```
    //
    // TODO: Better name? Or just docs?
    public func executeOrThrow(
        command: String,
        currentDirectory: String? = nil,
        environment: BashExecutorEnvironment = .current,
        stdoutDataHandler: @escaping (Data) -> () = { data in
            FileHandle.standardOutput.write(data)
        },
        stderrDataHandler: @escaping (Data) -> () = { data in
            FileHandle.standardError.write(data)
        })
        throws
        -> BashResult
    {
        let bashResult = try execute(
            command: command,
            currentDirectory: currentDirectory,
            environment: environment,
            stdoutDataHandler: stdoutDataHandler,
            stderrDataHandler: stderrDataHandler
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
        environment: BashExecutorEnvironment = .current)
        throws
        -> String
    {
        let bashResult = try execute(
            command: command,
            currentDirectory: currentDirectory,
            environment: environment,
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
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
