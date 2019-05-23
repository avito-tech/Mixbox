import Foundation

public final class TemporaryFileProviderImpl: TemporaryFileProvider {
    public init() {
    }
    
    public func temporaryFilePath() -> String {
        let path = NSTemporaryDirectory() + "/" + UUID().uuidString
        return path
    }
}
