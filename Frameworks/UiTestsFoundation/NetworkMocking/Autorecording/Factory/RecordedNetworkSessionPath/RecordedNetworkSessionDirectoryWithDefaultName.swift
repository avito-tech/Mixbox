public final class RecordedNetworkSessionDirectoryWithDefaultName: RecordedNetworkSessionDirectory {
    private let defaultName: String
    
    public init(directoryPath: String, defaultName: String) {
        self.defaultName = defaultName
        
        super.init(
            directoryPath: directoryPath
        )
    }
    
    public func withDefaultName() -> RecordedNetworkSessionPath {
        return withName(defaultName)
    }
    
    override public func inDirectoryWithRelativePath(
        relativePath: String)
        -> RecordedNetworkSessionDirectoryWithDefaultName
    {
        return RecordedNetworkSessionDirectoryWithDefaultName(
            directoryPath: directoryPath.mb_appendingPathComponent(relativePath),
            defaultName: defaultName
        )
    }
}
