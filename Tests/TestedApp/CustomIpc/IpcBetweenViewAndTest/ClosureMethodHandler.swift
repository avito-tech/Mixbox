import MixboxIpc

final class ClosureMethodHandler<MethodType: IpcMethod>: IpcMethodHandler {
    typealias Method = MethodType
    typealias Closure = (_ arguments: Method.Arguments, _ completion: @escaping (_ returnValue: Method.ReturnValue) -> ()) -> ()
    
    let method: Method
    
    private let closure: Closure
    
    init(
        method: Method,
        closure: @escaping Closure)
    {
        self.method = method
        self.closure = closure
    }
    
    func handle(
        arguments: Method.Arguments,
        completion: @escaping (_ returnValue: Method.ReturnValue) -> ())
    {
        closure(arguments, completion)
    }
}
