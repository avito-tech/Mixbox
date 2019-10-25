#if MIXBOX_ENABLE_IN_APP_SERVICES

public class KeyboardEvent: Codable {
    public let usagePage: UInt16
    public let usage: UInt16
    public let down: Bool
    
    public init(
        usagePage: UInt16,
        usage: UInt16,
        down: Bool)
    {
        self.usagePage = usagePage
        self.usage = usage
        self.down = down
    }
}

#endif
