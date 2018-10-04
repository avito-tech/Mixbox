// Method handler is placed on the server side.
//
// Example:
//
// final class GetAnswerToUltimateQuestionIpcMethodHandler: IpcMethodHandler {
//     let method = GetAnswerToUltimateQuestionIpcMethodHandler()
//
//     func handle(arguments: IpcVoid, completion: @escaping (_ result: Int) -> ()) {
//         return 2 * 3 * 7
//     }
// }
//
public protocol IpcMethodHandler: class {
    associatedtype Method: IpcMethod
    
    var method: Method { get }
    
    func handle(arguments: Method.Arguments, completion: @escaping (_ returnValue: Method.ReturnValue) -> ())
}
