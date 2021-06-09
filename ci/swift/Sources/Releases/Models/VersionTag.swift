public final class VersionTag {
    public init(
        version: Version,
        revision: String)
    {
        self.version = version
        self.revision = revision
    }
    
    public let version: Version
    public let revision: String
}
