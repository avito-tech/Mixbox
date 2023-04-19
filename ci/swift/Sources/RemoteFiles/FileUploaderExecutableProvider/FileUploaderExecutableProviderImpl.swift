import FileSystem
import CiFoundation
import Foundation
import PathLib

public final class FileUploaderExecutableProviderImpl: FileUploaderExecutableProvider {
    private let fileUploaderExecutableBase64: String
    private let temporaryFileProvider: TemporaryFileProvider
    private let dataWriter: DataWriter
    private let pathDeleter: PathDeleter
    
    public init(
        temporaryFileProvider: TemporaryFileProvider,
        dataWriter: DataWriter,
        pathDeleter: PathDeleter,
        fileUploaderExecutableBase64: String
    ) {
        self.temporaryFileProvider = temporaryFileProvider
        self.dataWriter = dataWriter
        self.pathDeleter = pathDeleter
        self.fileUploaderExecutableBase64 = fileUploaderExecutableBase64
    }
    
    public func fileUploaderExecutable() throws -> FileUploaderExecutable {
        let temporaryFilePath = AbsolutePath(temporaryFileProvider.temporaryFilePath())
        
        try dataWriter.write(
            data: try Data(
                base64Encoded: fileUploaderExecutableBase64
            ).unwrapOrThrow(),
            filePath: temporaryFilePath
        )
        
        return FileUploaderExecutable(
            path: temporaryFilePath,
            pathDeleter: pathDeleter
        )
    }
}

