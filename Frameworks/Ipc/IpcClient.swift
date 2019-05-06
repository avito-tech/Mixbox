import MixboxFoundation

// TODO: Replace with just ErrorString or something like that
public enum IpcClientError {
    case customError(String)
    case noResponse
    case encodingError
    case decodingError
}

public protocol IpcClient: class {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
}
