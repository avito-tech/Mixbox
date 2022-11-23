#if MIXBOX_ENABLE_FRAMEWORK_IPC && MIXBOX_DISABLE_FRAMEWORK_IPC
#error("Ipc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC)
// The compilation is disabled
#else

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
public protocol IpcMethodHandler: AnyObject {
    associatedtype Method: IpcMethod
    
    var method: Method { get }
    
    func handle(
        arguments: Method.Arguments,
        completion: @escaping (_ returnValue: Method.ReturnValue) -> ())
}

#endif
