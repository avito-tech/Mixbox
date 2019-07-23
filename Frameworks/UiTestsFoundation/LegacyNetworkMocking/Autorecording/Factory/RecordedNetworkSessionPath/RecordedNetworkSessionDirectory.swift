public class RecordedNetworkSessionDirectory {
    public let directoryPath: String
    
    public init(directoryPath: String) {
        self.directoryPath = directoryPath
    }
    
    public func inDirectoryWithRelativePath(relativePath: String) -> RecordedNetworkSessionDirectory {
        return RecordedNetworkSessionDirectory(
            directoryPath: directoryPath.mb_appendingPathComponent(relativePath)
        )
    }
    
    public func withName(_ name: String) -> RecordedNetworkSessionPath {
        return RecordedNetworkSessionPath(
            resourceName: name,
            sourceCodePath: directoryPath.mb_appendingPathComponent(name)
        )
    }
}
