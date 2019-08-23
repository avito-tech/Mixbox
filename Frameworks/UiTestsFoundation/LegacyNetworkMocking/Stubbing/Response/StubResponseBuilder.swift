import MixboxIpcCommon

public protocol StubResponseBuilder: class {
    // Do not use directly, use functions from extensions.
    // This function should be used only for implementing basic functionality.
    func withResponse(
        value: StubResponseBuilderResponseValue,
        variation: UrlProtocolVariation,
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
            variation: .http(headers: headers, statusCode: statusCode),
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
            variation: .http(headers: headers, statusCode: statusCode),
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
            variation: .http(headers: headers, statusCode: statusCode),
            responseTime: responseTime
        )
    }
}
