import Foundation

public final class DownloadingFileUploaderExecutableProvider: FileUploaderExecutableProvider {
    private let fileDownloader: FileDownloader
    private let fileUploaderUrl: URL
    
    public init(
        fileDownloader: FileDownloader,
        fileUploaderUrl: URL)
    {
        self.fileDownloader = fileDownloader
        self.fileUploaderUrl = fileUploaderUrl
    }
    
    public func fileUploaderExecutable() throws -> String {
        let uploader = try fileDownloader.download(url: fileUploaderUrl)
        
        try FileManager.default.setAttributes(
            [FileAttributeKey.posixPermissions : 0o777],
            ofItemAtPath: uploader
        )
        
        return uploader
    }
}
