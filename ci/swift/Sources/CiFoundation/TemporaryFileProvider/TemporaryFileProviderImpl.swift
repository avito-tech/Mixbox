import Foundation

public final class TemporaryFileProviderImpl: TemporaryFileProvider {
    public init() {
    }
    
    public func temporaryFilePath() -> String {
        return (NSTemporaryDirectory() as NSString)
            .appendingPathComponent(UUID().uuidString)
    }
}
