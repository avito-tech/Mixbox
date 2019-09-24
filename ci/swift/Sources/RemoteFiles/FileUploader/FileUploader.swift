import Foundation

public protocol FileUploader {
    func upload(
        file: String,
        remoteName: String)
        throws
        -> URL
}
