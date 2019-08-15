public final class FrameworkInfo {
    public let name: String
    public let needsIfs: Bool
    
    public init(
        name: String,
        needsIfs: Bool)
    {
        self.name = name
        self.needsIfs = needsIfs
    }
}
