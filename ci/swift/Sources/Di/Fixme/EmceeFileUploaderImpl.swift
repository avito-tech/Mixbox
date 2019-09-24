import Foundation
import CiFoundation
import Emcee
import SingletonHell
import RemoteFiles

public final class EmceeFileUploaderImpl: EmceeFileUploader {
    private let fileUploader: FileUploader
    
    public init(fileUploader: FileUploader) {
        self.fileUploader = fileUploader
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
        let temporaryDirectory = Variables.newTemporaryDirectory()
        
        try mkdirp(temporaryDirectory)
        
        let basename = (file as NSString).lastPathComponent
        
        try bash(
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
        return try bash(
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
