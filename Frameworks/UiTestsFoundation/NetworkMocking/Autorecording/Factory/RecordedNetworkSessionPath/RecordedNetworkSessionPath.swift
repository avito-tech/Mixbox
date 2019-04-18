import MixboxFoundation

public final class RecordedNetworkSessionPath {
    public let resourceName: String // e.g.: "session.json"
    public let sourceCodePath: String // e.g.: "/path/to/session.json"
    
    public static let defaultExtension = "recordedNetworkSession.json"
    
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
    
    public func addDefaultExtension() -> RecordedNetworkSessionPath {
        return RecordedNetworkSessionPath(
            resourceName: resourceName + ".\(RecordedNetworkSessionPath.defaultExtension)",
            sourceCodePath: sourceCodePath + ".\(RecordedNetworkSessionPath.defaultExtension)"
        )
    }
    
    public static func nearHere(
        file: StaticString = #file)
        -> RecordedNetworkSessionDirectoryWithDefaultName
    {
        let defaultName = "\(file)"
            .mb_lastPathComponent
            .split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)
            .first
            .map(String.init)
            .map { "\($0).\(defaultExtension)" }
        
        return RecordedNetworkSessionDirectoryWithDefaultName(
            directoryPath: "\(file)".mb_deletingLastPathComponent,
            defaultName: defaultName ?? defaultExtension
        )
    }
    
    public static func `default`(
        file: StaticString = #file)
        -> RecordedNetworkSessionPath
    {
        return nearHere(file: file).withDefaultName()
    }
}
