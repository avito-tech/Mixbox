#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class BonjourIpcService {
    public let host: String
    public let port: UInt
    
    public init(
        host: String,
        port: UInt)
    {
        self.host = host
        self.port = port
    }
}

#endif
