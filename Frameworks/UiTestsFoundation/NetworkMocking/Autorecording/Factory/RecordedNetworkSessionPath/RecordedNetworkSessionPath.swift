import MixboxFoundation

public final class RecordedNetworkSessionPath {
    public let resourceName: String // e.g.: "session.json"
    public let sourceCodePath: String // e.g.: "/path/to/session.json"
    
    public init(
        resourceName: String,
        sourceCodePath: String)
    {
        self.resourceName = resourceName
        self.sourceCodePath = sourceCodePath
    }
    
    public static func near<T: StringProtocol>(
        file: T)
        -> RecordedNetworkSessionDirectory
    {
        return RecordedNetworkSessionDirectory(
            directoryPath: "\(file)".mb_deletingLastPathComponent
        )
    }
    
    public static func nearHere(
        file: StaticString = #file)
        -> RecordedNetworkSessionDirectoryWithDefaultName
    {
        let suffix = "recordedNetworkSession.json"
        
        let defaultName = "\(file)"
            .mb_lastPathComponent
            .split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map(String.init)
            .map { "\($0).\(suffix)" }
        
        return RecordedNetworkSessionDirectoryWithDefaultName(
            directoryPath: "\(file)".mb_deletingLastPathComponent,
            defaultName: defaultName ?? suffix
        )
    }
    
    public static func `default`(
        file: StaticString = #file)
        -> RecordedNetworkSessionPath
    {
        return nearHere(file: file).withDefaultName()
    }
}
