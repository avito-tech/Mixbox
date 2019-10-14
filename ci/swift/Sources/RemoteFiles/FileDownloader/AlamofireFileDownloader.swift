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
        let numberOfDownloadingAttempts = 5
        let timeIntervalBetweenAttempts: TimeInterval = 10
        var lastErrorOrNil: Error?
        var lastResultOrNil: String?
        
        for attemptIndex in 0..<numberOfDownloadingAttempts {
            do {
                lastResultOrNil = try attemptToDownloadOnce(url: url)
                lastErrorOrNil = nil
            } catch {
                lastErrorOrNil = error
                
                let lastAttemptIndex = numberOfDownloadingAttempts - 1
                if attemptIndex < lastAttemptIndex {
                    Thread.sleep(forTimeInterval: timeIntervalBetweenAttempts)
                }
            }
        }
        
        if let lastError = lastErrorOrNil {
            throw lastError
        } else if let lastResult = lastResultOrNil {
            return lastResult
        } else {
            throw ErrorString("Internal error in AlamofireFileDownloader, expected to have either result or error")
        }
    }
    
    private func attemptToDownloadOnce(url: URL) throws -> String {
        let downloadedFilePath = temporaryFileProvider.temporaryFilePath()
        
        var errorOrNil: Error?
        var completed: Bool = false
        
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
                
                completed = true
            }
        }
        
        let start = Date()
        let timeout: TimeInterval = 60
        while !completed && Date().timeIntervalSince(start) < timeout {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        if let error = errorOrNil {
            throw error
        }
        
        if !FileManager.default.fileExists(atPath: downloadedFilePath) {
            throw ErrorString(
                """
                Failed to download file from '\(url)', downloaded file doesn't \
                exist on file system at path \(downloadedFilePath)
                """
            )
        }
        
        return downloadedFilePath
    }
}
