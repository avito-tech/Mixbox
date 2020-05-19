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
        do {
            let result = try callSynchronously(
                method: method,
                arguments: arguments
            )
            
            completion(.data(result))
        } catch {
            completion(.error(error))
        }
    }
    
    private func callSynchronously<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        throws
        -> Method.ReturnValue
    {
        let encodedObject = try GenericSerialization.serialize(value: arguments)
        
        let response = application.performCustomCommandNamed(
            "customCommand:\(method.name)",
            object: encodedObject
        )
        
        guard let receivedResponse = response else {
            throw ErrorString("performCustomCommandNamed returened nil")
        }
        
        guard let stringResponse = receivedResponse as? String else {
            throw ErrorString("performCustomCommandNamed returned object that is not string: \(receivedResponse)")
        }
        
        let decodedResponse: Method.ReturnValue = try GenericSerialization.deserialize(string: stringResponse)
        
        return decodedResponse
    }
}
