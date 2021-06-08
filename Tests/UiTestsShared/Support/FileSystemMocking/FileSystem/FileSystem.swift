import MixboxFoundation

// Facade for mocking file system
public protocol FileSystem: AnyObject {
    func temporaryFile(name: String?) -> TemporaryFile
    func temporaryDirectory(name: String?) -> TemporaryDirectory
}

extension FileSystem {
    public func temporaryFile() -> TemporaryFile {
        return temporaryFile(name: nil)
    }
    
    public func temporaryDirectory() -> TemporaryDirectory {
        return temporaryDirectory(name: nil)
    }
}
