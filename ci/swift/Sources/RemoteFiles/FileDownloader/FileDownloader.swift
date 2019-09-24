import Foundation

public protocol FileDownloader {
    // Returns path to existing downloaded file
    func download(url: URL) throws -> String
}
