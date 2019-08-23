import MixboxIpcCommon

public protocol StubResponseBuilder: class {
    // Do not use directly, use functions from extensions.
    // This function should be used only for implementing basic functionality.
    func withResponse(
        value: StubResponseBuilderResponseValue,
        variation: URLResponseProtocolVariation,
        responseTime: TimeInterval)
}

extension StubResponseBuilder {
    public func thenReturn(
        file: String,
        headers: [String: String] = [:],
        statusCode: Int = 200,
        responseTime: TimeInterval = 0)
    {
        return withResponse(
            value: .file(file),
            variation: .http(
                HTTPURLResponseVariation(
                    headers: headers,
                    statusCode: statusCode
                )
            ),
            responseTime: responseTime
        )
    }
    
    public func thenReturn(
        string: String,
        headers: [String: String] = [:],
        statusCode: Int = 200,
        responseTime: TimeInterval = 0)
    {
        return withResponse(
            value: .string(string),
            variation: .http(
                HTTPURLResponseVariation(
                    headers: headers,
                    statusCode: statusCode
                )
            ),
            responseTime: responseTime
        )
    }
    
    public func thenReturn(
        data: Data,
        headers: [String: String] = [:],
        statusCode: Int = 200,
        responseTime: TimeInterval = 0)
    {
        return withResponse(
            value: .data(data),
            variation: .http(
                HTTPURLResponseVariation(
                    headers: headers,
                    statusCode: statusCode
                )
            ),
            responseTime: responseTime
        )
    }
    
    public func thenReturn(
        data: Data,
        mimeType: String?,
        expectedContentLength: Int64,
        textEncodingName: String?,
        responseTime: TimeInterval = 0
    ) {
        return withResponse(
            value: .data(data),
            variation: .bare(
                BareURLResponseVariation(
                    mimeType: mimeType,
                    expectedContentLength: expectedContentLength,
                    textEncodingName: textEncodingName
                )
            ),
            responseTime: responseTime
        )
    }
}
