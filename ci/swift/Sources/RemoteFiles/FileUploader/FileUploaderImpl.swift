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
            let result = try processExecutor.executeOrThrow(
                arguments: [fileUploaderExecutable.path.pathString, file, remoteName],
                currentDirectory: nil,
                environment: [:],
                outputHandling: .ignore
            )
            let remotePath = try result.stdout.trimmedUtf8String().unwrapOrThrow()
            return try URL.from(string: remotePath)
        }
    }
}
