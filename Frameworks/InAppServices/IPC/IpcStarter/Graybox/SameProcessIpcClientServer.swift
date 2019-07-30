#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

public final class SameProcessIpcClientServer: IpcRouter, IpcClient {
    typealias AnyHandler = (Any, @escaping (DataResult<Any, Error>) -> ()) -> ()
    
    private var anyHandlersByMethodName = [String: AnyHandler]()
    
    public init() {
    }
    
    public func call<Method>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, Error>) -> ())
        where Method : IpcMethod
    {
        guard let anyHandler = anyHandlersByMethodName[method.name] else {
            completion(.error(ErrorString("Method is not registered"))) // TODO: Better error
            return
        }
        
        anyHandler(arguments) { result in
            let typedResult = result.flatMapData { (anyReturnValue) -> DataResult<Method.ReturnValue, Error> in
                if let typedReturnValue = anyReturnValue as? Method.ReturnValue {
                    return .data(typedReturnValue)
                } else {
                    return .error(
                        ErrorString(
                            """
                            ReturnValue of handler of method "\(method.name)" \
                            is unexpected: "\(type(of: anyReturnValue))", \
                            expected: "\(DataResult<Method.ReturnValue, Error>.self)"
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
                completion(.error(ErrorString(
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
        anyHandlersByMethodName[methodHandler.method.name] = anyHandler
    }
}

#endif
