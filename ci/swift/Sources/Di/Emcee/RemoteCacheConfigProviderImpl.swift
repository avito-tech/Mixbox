import RemoteFiles
import Emcee
import Foundation

public class RemoteCacheConfigProviderImpl: RemoteCacheConfigProvider {
    private let fileDownloader: FileDownloader
    private let remoteCacheConfigJsonUrl: URL
    
    public init(
        fileDownloader: FileDownloader,
        remoteCacheConfigJsonUrl: URL)
    {
        self.fileDownloader = fileDownloader
        self.remoteCacheConfigJsonUrl = remoteCacheConfigJsonUrl
    }
    
    public func remoteCacheConfigJsonFilePath() throws -> String {
        return try fileDownloader.download(url: remoteCacheConfigJsonUrl)
    }
}
