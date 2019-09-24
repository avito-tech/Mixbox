import Foundation

public protocol EmceeFileUploader {
    func upload(path: String) throws -> URL
}
