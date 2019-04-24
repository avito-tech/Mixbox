import MixboxIpc
import MixboxFoundation

public final class SameProcessIpcClientServer: IpcRouter, IpcClient {
    typealias AnyHandler = (Any, @escaping (DataResult<Any, IpcClientError>) -> ()) -> ()
    
    private var anyHandlers = [String: AnyHandler]()
    
    public init() {
    }
    
    public func call<Method>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
        where Method : IpcMethod
    {
        guard let anyHandler = anyHandlers[method.name] else {
            completion(.error(.customError("Method is not registered")))
            return
        }
        
        anyHandler(arguments) { result in
            let typedResult = result.flatMapData { (anyReturnValue) -> DataResult<Method.ReturnValue, IpcClientError> in
                if let typedReturnValue = anyReturnValue as? Method.ReturnValue {
                    return .data(typedReturnValue)
                } else {
                    return .error(
                        .customError(
                            """
                            ReturnValue of handler of method "\(method.name)" \
                            is unexpected: "\(type(of: anyReturnValue))", \
                            expected: "\(DataResult<Method.ReturnValue, IpcClientError>.self)"
                            """
                        )
                    )
                }
            }
            
            completion(typedResult)
        }
    }
    
    public func register<MethodHandler: IpcMethodHandler>(methodHandler: MethodHandler) {
        let anyHandler: AnyHandler = { arguments, completion in
            guard let typedArguments = arguments as? MethodHandler.Method.Arguments else {
                completion(.error(.customError(
                    """
                    Expected arguments type for method "\(methodHandler.method.name)": \
                    "\(MethodHandler.Method.Arguments.self)", \
                    actual type: "\(type(of: arguments))"
                    """
                )))
                return
            }
            
            methodHandler.handle(
                arguments: typedArguments,
                completion: { returnValue in
                    completion(.data(returnValue))
                }
            )
        }
        
        // TODO: What to do if method is getting overwritten?
        anyHandlers[methodHandler.method.name] = anyHandler
    }
}
