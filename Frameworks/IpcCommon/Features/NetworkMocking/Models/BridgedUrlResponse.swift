#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class BridgedUrlResponse: Codable {
    public let url: URL?
    public let variation: UrlProtocolVariation
    
    public init(
        url: URL?,
        variation: UrlProtocolVariation)
    {
        self.url = url
        self.variation = variation
    }
}

#endif
