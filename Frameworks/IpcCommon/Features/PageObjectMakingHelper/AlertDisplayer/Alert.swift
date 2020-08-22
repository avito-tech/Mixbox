#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class Alert: Codable {
    public let title: String
    public let description: String
    
    public init(
        title: String,
        description: String)
    {
        self.title = title
        self.description = description
    }
}

#endif
