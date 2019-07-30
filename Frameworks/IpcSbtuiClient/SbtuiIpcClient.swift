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
        completion: @escaping (DataResult<Method.ReturnValue, Error>) -> ())
    {
        guard let encodedObject = GenericSerialization.serialize(value: arguments) else {
            completion(.error(ErrorString("encodingError"))) // TODO: Better error
            return
        }
        
        let response = application.performCustomCommandNamed(
            "customCommand:\(method.name)",
            object: encodedObject
        )
        
        guard let receivedResponse = response else {
            completion(.error(ErrorString("noResponse"))) // TODO: Better error
            return
        }
        
        guard let stringResponse = receivedResponse as? String else {
            completion(.error(ErrorString("decodingError"))) // TODO: Better error
            return
        }
        
        guard let decodedResponse: Method.ReturnValue = GenericSerialization.deserialize(string: stringResponse) else {
            completion(.error(ErrorString("decodingError"))) // TODO: Better error
            return
        }
        
        completion(.data(decodedResponse))
    }
}
