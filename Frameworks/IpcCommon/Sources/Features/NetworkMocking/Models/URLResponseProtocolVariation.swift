#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

public enum URLResponseProtocolVariation: Equatable, Codable {
    case bare(BareURLResponseVariation)
    case http(HTTPURLResponseVariation)
    
    public init(from decoder: Decoder) throws {
        if let bare = try? BareURLResponseVariation(from: decoder) {
            self = .bare(bare)
        } else {
            self = try .http(HTTPURLResponseVariation(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .bare(bare):
            try bare.encode(to: encoder)
        case let .http(http):
            try http.encode(to: encoder)
        }
    }
    
    public static func ==(lhs: URLResponseProtocolVariation, rhs: URLResponseProtocolVariation) -> Bool {
        switch (lhs, rhs) {
        case let (.bare(lhsVariation), .bare(rhsVariation)):
            return lhsVariation == rhsVariation
        case let (.http(lhsVariation), .http(rhsVariation)):
            return lhsVariation == rhsVariation
        default:
            return false
        }
    }
}

public struct BareURLResponseVariation: Equatable, Codable {
    public let mimeType: String?
    public let expectedContentLength: Int64
    public let textEncodingName: String?
    
    public init(
        mimeType: String?,
        expectedContentLength: Int64,
        textEncodingName: String?)
    {
        self.mimeType = mimeType
        self.expectedContentLength = expectedContentLength
        self.textEncodingName = textEncodingName
    }
}

public struct HTTPURLResponseVariation: Equatable, Codable {
    public let headers: [String: String]
    public let statusCode: Int
    
    public init(
        headers: [String: String],
        statusCode: Int)
    {
        self.headers = headers
        self.statusCode = statusCode
    }
}

#endif
