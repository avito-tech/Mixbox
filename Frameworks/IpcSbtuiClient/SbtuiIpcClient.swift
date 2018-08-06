import MixboxFoundation
import MixboxIpc
import SBTUITestTunnel

public final class SbtuiIpcClient: IpcClient {
    private let application: SBTUITunneledApplication
    
    public init(application: SBTUITunneledApplication) {
        self.application = application
    }
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
    {
        guard let encodedObject = GenericSerialization.serialize(value: arguments) else {
            completion(.error(.encodingError))
            return
        }
        
        let response = application.performCustomCommandNamed(
            "customCommand:\(method.name)",
            object: encodedObject
        )
        
        guard let receivedResponse = response else {
            completion(.error(.noResponse))
            return
        }
        
        guard let stringResponse = receivedResponse as? String else {
            completion(.error(.decodingError))
            return
        }
        
        guard let decodedResponse: Method.ReturnValue = GenericSerialization.deserialize(string: stringResponse) else {
            completion(.error(.decodingError))
            return
        }
        
        completion(.data(decodedResponse))
    }
}
