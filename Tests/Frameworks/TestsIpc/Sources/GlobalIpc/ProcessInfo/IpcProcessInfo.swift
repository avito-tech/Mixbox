public final class IpcProcessInfo: Codable {
    public let environment: [String: String]
    public let arguments: [String]
    public let hostName: String
    public let processName: String
    public let processIdentifier: Int32
    
    public init(
        environment: [String: String],
        arguments: [String],
        hostName: String,
        processName: String,
        processIdentifier: Int32)
    {
        self.environment = environment
        self.arguments = arguments
        self.hostName = hostName
        self.processName = processName
        self.processIdentifier = processIdentifier
    }
}
