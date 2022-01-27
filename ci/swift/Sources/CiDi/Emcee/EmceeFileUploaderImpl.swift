import Foundation
import CiFoundation
import Emcee
import SingletonHell
import RemoteFiles
import Bash

public final class EmceeFileUploaderImpl: EmceeFileUploader {
    private let fileUploader: FileUploader
    private let temporaryFileProvider: TemporaryFileProvider
    private let bashExecutor: BashExecutor
    
    public init(
        fileUploader: FileUploader,
        temporaryFileProvider: TemporaryFileProvider,
        bashExecutor: BashExecutor)
    {
        self.fileUploader = fileUploader
        self.temporaryFileProvider = temporaryFileProvider
        self.bashExecutor = bashExecutor
    }
    
    public func upload(path: String) throws -> URL {
        let basename = (path as NSString).lastPathComponent
        let components = basename.components(separatedBy: ".")
        
        guard let `extension` = components.last else {
            throw ErrorString("upload requires file to have an extension. file: \(path)")
        }
        
        let filename = components.dropLast().joined(separator: ".")
        
        let sum = try checksum(file: path)
        
        return try upload_zipped_for_emcee(
            file: path,
            remoteName: "\(filename)-\(sum).\(`extension`)"
        )
    }
    
    public func upload_zipped_for_emcee(
        file: String)
        throws
        -> URL
    {
        return try upload_zipped_for_emcee(
            file: file,
            remoteName: (file as NSString).lastPathComponent
        )
    }
    
    public func upload_zipped_for_emcee(
        file: String,
        remoteName: String)
        throws
        -> URL
    {
        let temporaryDirectory = temporaryFileProvider.temporaryFilePath()
        try FileManager.default.createDirectory(
            atPath: temporaryDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        let basename = (file as NSString).lastPathComponent
        
        _ = try bashExecutor.executeOrThrow(
            command: """
            zip -r "\(temporaryDirectory)/\(remoteName).zip" "\(basename)" 1>/dev/null 2>/dev/null
            """,
            currentDirectory: (file as NSString).deletingLastPathComponent
        )
        
        let remoteZip = try fileUploader.upload(
            file: "\(temporaryDirectory)/\(remoteName).zip",
            remoteName: "\(remoteName).zip"
        )
        
        return try URL.from(string: "\(remoteZip.absoluteString)#\(basename)")
    }
    
    // supports folders
    public func checksum(file: String) throws -> String {
        return try bashExecutor.executeAndReturnTrimmedOutputOrThrow(
            command:
            """
            set -o pipefail
            find "\(file)" -type f -print0 \
            | sort -z \
            | xargs -0 shasum \
            | shasum \
            | grep -oE "^\\S+"
            """
        )
    }
}
