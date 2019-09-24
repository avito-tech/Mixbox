import Foundation
import CiFoundation
import Bash

public final class FileUploaderImpl: FileUploader {
    private let fileUploaderExecutableProvider: FileUploaderExecutableProvider
    private let processExecutor: ProcessExecutor
    
    public init(
        fileUploaderExecutableProvider: FileUploaderExecutableProvider,
        processExecutor: ProcessExecutor)
    {
        self.fileUploaderExecutableProvider = fileUploaderExecutableProvider
        self.processExecutor = processExecutor
    }
    
    public func upload(
        file: String,
        remoteName: String)
        throws
        -> URL
    {
        let fileUploaderExecutable = try fileUploaderExecutableProvider.fileUploaderExecutable()
        
        let result = try processExecutor.execute(
            executable: fileUploaderExecutable,
            arguments: [file, remoteName],
            currentDirectory: nil,
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        if result.code != 0 {
            throw ErrorString(
                """
                Failed to execute "\(fileUploaderExecutable)" with exit code \(result.code)"
                """
            )
        }
        
        let remotePath = try result.stdout.trimmedUtf8String().unwrapOrThrow()
        
        return try URL.from(string: remotePath)
    }
}
