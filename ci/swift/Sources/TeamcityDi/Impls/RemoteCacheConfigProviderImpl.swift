import RemoteFiles
import Emcee
import Foundation

public class RemoteCacheConfigProviderImpl: RemoteCacheConfigProvider {
    private let storedRemoteCacheConfigJsonFilePath: String
    
    public init(
        remoteCacheConfigJsonFilePath: String
    ) {
        self.storedRemoteCacheConfigJsonFilePath = remoteCacheConfigJsonFilePath
    }
    
    public func remoteCacheConfigJsonFilePath() -> String {
        return storedRemoteCacheConfigJsonFilePath
    }
}
