import MixboxIpc

public final class ClosureMethodHandler<MethodType: IpcMethod>: IpcMethodHandler {
    public typealias Method = MethodType
    public typealias Closure = (_ arguments: Method.Arguments, _ completion: @escaping (_ returnValue: Method.ReturnValue) -> ()) -> ()
    
    public let method: Method
    
    private let closure: Closure
    
    public init(
        method: Method,
        closure: @escaping Closure)
    {
        self.method = method
        self.closure = closure
    }
    
    public func handle(
        arguments: Method.Arguments,
        completion: @escaping (_ returnValue: Method.ReturnValue) -> ())
    {
        closure(arguments, completion)
    }
}
