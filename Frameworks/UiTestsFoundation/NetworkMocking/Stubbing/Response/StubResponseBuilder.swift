public protocol StubResponseBuilder: class {
    // Do not use directly, use functions from extensions.
    // This function should be used only for implementing basic functionality.
    func withResponse(
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
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
            headers: headers,
            statusCode: statusCode,
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
            headers: headers,
            statusCode: statusCode,
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
            headers: headers,
            statusCode: statusCode,
            responseTime: responseTime
        )
    }
}
