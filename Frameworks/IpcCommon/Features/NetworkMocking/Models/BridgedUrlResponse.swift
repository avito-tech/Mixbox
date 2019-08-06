#if MIXBOX_ENABLE_IN_APP_SERVICES

// Replicates URLResponse
public final class BridgedUrlResponse: Codable {
    public let url: URL?
    public let mimeType: String?
    public let expectedContentLength: Int64
    public let textEncodingName: String?
    
    public init(
        url: URL?,
        mimeType: String?,
        expectedContentLength: Int64,
        textEncodingName: String?)
    {
        self.url = url
        self.mimeType = mimeType
        self.expectedContentLength = expectedContentLength
        self.textEncodingName = textEncodingName
    }
}

#endif
