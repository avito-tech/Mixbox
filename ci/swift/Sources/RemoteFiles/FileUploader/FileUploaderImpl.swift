import Foundation
import CiFoundation
import Bash

public final class FileUploaderImpl: FileUploader {
    private let fileUploaderExecutableProvider: FileUploaderExecutableProvider
    private let processExecutor: ProcessExecutor
    private let retrier: Retrier
    
    public init(
        fileUploaderExecutableProvider: FileUploaderExecutableProvider,
        processExecutor: ProcessExecutor,
        retrier: Retrier)
    {
        self.fileUploaderExecutableProvider = fileUploaderExecutableProvider
        self.processExecutor = processExecutor
        self.retrier = retrier
    }
    
    public func upload(
        file: String,
        remoteName: String)
        throws
        -> URL
    {
        let fileUploaderExecutable = try fileUploaderExecutableProvider.fileUploaderExecutable()
        
        return try retrier.retry(timeouts: [30, 60, 120, 300]) {
            let result = try processExecutor.execute(
                arguments: [fileUploaderExecutable, file, remoteName],
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
}
