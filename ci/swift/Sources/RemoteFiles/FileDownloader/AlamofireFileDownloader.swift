import Foundation
import CiFoundation
import Alamofire

// TODO: Make it asynchronous
public final class AlamofireFileDownloader: FileDownloader {
    private let temporaryFileProvider: TemporaryFileProvider
    
    public init(
        temporaryFileProvider: TemporaryFileProvider)
    {
        self.temporaryFileProvider = temporaryFileProvider
    }
    
    public func download(url: URL) throws -> String {
        let downloadedFilePath = temporaryFileProvider.temporaryFilePath()
        
        let dispatchGroup = DispatchGroup()
        var errorOrNil: Error?
        
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(url).responseData { response in
                if let error = response.error {
                    errorOrNil = error
                } else if let data = response.result.value {
                    do {
                        try data.write(to: URL(fileURLWithPath: downloadedFilePath), options: .atomicWrite)
                    } catch {
                        errorOrNil = error
                    }
                } else {
                    errorOrNil = ErrorString("Alamofire didn't return neither error, nor data in responseData")
                }
                dispatchGroup.leave()
            }
        }
        
        let start = Date()
        while Date().timeIntervalSince(start) < 60, !FileManager.default.fileExists(atPath: downloadedFilePath) {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        if let error = errorOrNil {
            throw error
        }
        
        if !FileManager.default.fileExists(atPath: downloadedFilePath) {
            throw ErrorString("Failed to download file from '\(url)', file doesn't exist")
        }
        
        return downloadedFilePath
    }
}
