import Foundation

public protocol FileDownloader {
    func download(url: URL) throws -> String
}
