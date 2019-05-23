import Foundation
import CiFoundation

// Translated from `remoteFiles.sh`.
// TODO: Rewrite.
public final class RemoteFiles {
    private static var __MIXBOX_CI_UPLOADER_EXECUTABLE: String?
    
    public static func upload_hashed_zipped_for_emcee(
        file: String)
        throws
        -> String
    {
        let basename = (file as NSString).lastPathComponent
        let components = basename.components(separatedBy: ".")
        
        guard components.count > 1 else {
            throw ErrorString("upload_hashed_zipped_for_emcee requires file to have an extension. file: \(file)")
        }
        let `extension` = components.last!
        let filename = components.dropLast().joined(separator: ".")
        
        let sum = try checksum(file: file)
    
        return try upload_zipped_for_emcee(
            file: file,
            remoteName: "\(filename)-\(sum).\(`extension`)"
        )
    }
    
    public static func upload_zipped_for_emcee(
        file: String)
        throws
        -> String
    {
        return try upload_zipped_for_emcee(
            file: file,
            remoteName: (file as NSString).lastPathComponent
        )
    }
    
    public static func upload_zipped_for_emcee(
        file: String,
        remoteName: String)
        throws
        -> String
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
        
        let remoteZip = try upload(
            file: "\(temporaryDirectory)/\(remoteName).zip",
            remoteName: "\(remoteName).zip"
        )
        
        return "\(remoteZip)#\(basename)"
    }
    
    public static func upload(
        file: String,
        remoteName: String)
        throws
        -> String
    {
        let uploader: String
        
        if let localUploader = __MIXBOX_CI_UPLOADER_EXECUTABLE {
            uploader = localUploader
        } else {
            uploader = try download(
                url: try Env.MIXBOX_CI_FILE_UPLOADER_URL.getOrThrow()
            )
        }
        
        try bash(
            """
            chmod +x "\(uploader)"
            """
        )
        return try bash(
            """
            "\(uploader)" "\(file)" "\(remoteName)"
            """
        )
    }
    
    public static func download(url: String) throws -> String {
        let temporaryDirectory = Variables.newTemporaryDirectory()
        
        try mkdirp(temporaryDirectory)
        
        let tempFile = temporaryDirectory + "/" + uuidgen()
        
        try bash(
            """
            set -o pipefail
            curl "\(url)" -o "\(tempFile)" | cat
            """
        )
        
        return tempFile
    }
    
    // supports folders
    public static func checksum(file: String) throws -> String {
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
