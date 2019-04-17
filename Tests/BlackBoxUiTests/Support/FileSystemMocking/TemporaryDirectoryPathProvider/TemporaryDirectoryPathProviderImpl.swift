public final class NsTemporaryDirectoryPathProvider: TemporaryDirectoryPathProvider {
    public init() {
    }
    
    public func temporaryDirectoryPath() -> String {
        return NSTemporaryDirectory()
    }
}
