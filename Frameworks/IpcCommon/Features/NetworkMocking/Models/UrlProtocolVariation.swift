#if MIXBOX_ENABLE_IN_APP_SERVICES

public enum UrlProtocolVariation: Equatable, Codable {
    case bare(mimeType: String?, expectedContentLength: Int64, textEncodingName: String?)
    case http(headers: [String: String], statusCode: Int)
    
    public init(from decoder: Decoder) throws {
        if let bare = try? BareProtocolVariation(from: decoder) {
            self = .bare(
                mimeType: bare.mimeType,
                expectedContentLength: bare.expectedContentLength,
                textEncodingName: bare.textEncodingName
            )
        } else {
            let http = try HTTPProtocolVariation(from: decoder)
            self = .http(headers: http.headers, statusCode: http.statusCode)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .bare(
            mimeType: mimeType,
            expectedContentLength: expectedContentLength,
            textEncodingName: textEncodingName):
            try BareProtocolVariation(
                mimeType: mimeType,
                expectedContentLength: expectedContentLength,
                textEncodingName: textEncodingName
            ).encode(to: encoder)
        case let .http(headers: headers, statusCode: statusCode):
            try HTTPProtocolVariation(
                headers: headers,
                statusCode: statusCode
            ).encode(to: encoder)
        }
    }
}

private struct BareProtocolVariation: Codable {
    let mimeType: String?
    let expectedContentLength: Int64
    let textEncodingName: String?
}

private struct HTTPProtocolVariation: Codable {
    let headers: [String: String]
    let statusCode: Int
}

#endif
