public final class CreatedTemporaryDirectory: TemporaryDirectory {
    public let path: String
    
    private let fileManager: FileManager
    
    // File should exist at the path
    public init(
        path: String,
        fileManager: FileManager)
    {
        self.path = path
        self.fileManager = fileManager
    }
    
    deinit {
        try? fileManager.removeItem(atPath: path)
    }
}
